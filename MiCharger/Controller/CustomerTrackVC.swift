//
//  CustomerTrackVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-28.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import KOControls

class CustomerTrackVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var otpVerifyView: UIView!
    @IBOutlet weak var otpTF: KOTextField!
    
    //MARK: CONTANTS
    let locationService = LocationService.shared
    let locationManager = CLLocationManager()
    let webService = WebService.shared
    
    //MARK: VARIABLES
    var originMaker: GMSMarker?
    var destinationMarker: GMSMarker?
    var routePolyLine: GMSPolyline?
    var markersArray = [GMSMarker]()
    var wayPointsArray = [String]()
    
    var timer: Timer?
    var acceptedOrder: AcceptedOrderModel!
    var vehicleFare: VehicleFareModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set verify Otp View
        otpVerifyView.isHidden = true
        otpTF.addHideinputAccessoryView()
        otpTF.errorInfo.description = "Invalid OTP"
        otpTF.validation.add(validator: KOFunctionTextValidator(function: { otp -> Bool in
            return otp.count == 4
        }))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideVerifyOtpView))
        otpVerifyView.addGestureRecognizer(tap)
        
        // Set Customer details View
        guard let acceptOrderModel = webService.acceptedOrder else {return}
        self.acceptedOrder = acceptOrderModel
        customerNameLbl.text = acceptedOrder.customerName
        vehicleImage.downloadedFrom(link: acceptedOrder.vehicleImageLink)
        vehicleNameLbl.text = acceptedOrder.vehicleName
        
        // Set Map View
        locationManager.delegate = self
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(showCustomerLocation), userInfo: nil, repeats: true)
        showCustomerLocation()
    }
    
    @IBAction func onBackBtnPressed(sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOtpBtnPressed(sender: UIButton) {
        UIView.animate(withDuration: 3.0) {
            self.otpVerifyView.isHidden = false
        }
    }
    
    @IBAction func verifyOtpBtnPressed(sender: UIButton) {
        let otp = otpTF.text!
        var isValidOtp = true
        
        if otp.count != 6 {
            isValidOtp = false
            otpTF.error.isShowing = true
            return
        }
        
        if checkInternetAvailablity() {
            if isValidOtp {
                startAnimate(with: "")
                webService.verifyOtpForCharge(orderId: acceptedOrder.orderId, otp: otp, chargerId: webService.userId) { (status, message, data) in
                    if status == 1 {
                        self.timer?.invalidate()
                        self.timer = nil
                        guard let fareModel = data else {return}
                        self.vehicleFare = fareModel
                        self.stopAnimating()
                        self.performSegue(withIdentifier: TRACK_CUSTOMERVC_TO_CHARGER_READINGVC, sender: self)
                    }
                    else {
                        self.stopAnimating()
                        _ = SweetAlert().showAlert("Error", subTitle: message, style: .none)
                    }
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    @objc
    func hideVerifyOtpView() {
        UIView.animate(withDuration: 3.0) {
            self.otpVerifyView.isHidden = true
        }
    }
    
    @objc
    func showCustomerLocation() {
        let chargerLocation = CLLocationCoordinate2DMake(self.locationService.myCurrentLatitude, self.locationService.myCurrentLongitude)
        let customerLocation = CLLocationCoordinate2DMake(acceptedOrder.customerLatitude, acceptedOrder.customerLongitude)
        LocationService.shared.getDirectionsFromgeoCode(originLat: chargerLocation.latitude, originLon: chargerLocation.longitude, destinalat: customerLocation.latitude, destLon: customerLocation.longitude, wayPoints: [], travelMode: "driving" as AnyObject) { (success) in
            if success {
                DispatchQueue.main.async {
                    print("Poly Line Success")
                    self.configureMapAndMarkersForRoute(customerCoordinates: customerLocation)
                    self.drawRoute()
                }
            }
        }
    }
    
    func configureMapAndMarkersForRoute(customerCoordinates: CLLocationCoordinate2D) {
        let chargerLocation = CLLocationCoordinate2DMake(locationService.myCurrentLatitude, locationService.myCurrentLongitude)
        mapView.camera = GMSCameraPosition.camera(withTarget: chargerLocation, zoom: 15.0)
        
        originMaker = GMSMarker(position: chargerLocation)
        originMaker?.map = self.mapView
        originMaker?.icon = UIImage(named: "chargerIcon")
        originMaker?.snippet = "Charger"
        self.mapView.selectedMarker = originMaker
        
        let customerLocation = customerCoordinates
        destinationMarker = GMSMarker(position: customerLocation)
        destinationMarker?.map = self.mapView
        destinationMarker?.icon = UIImage(named: "trackIcon")
        destinationMarker?.snippet = "User"
        self.mapView.selectedMarker = destinationMarker
        
        
        if wayPointsArray.count > 0 {
            for wapoint in wayPointsArray {
                let reqCoOrdinate = wapoint.components(separatedBy: ",")
                let lat: Double = Double(reqCoOrdinate[0])!
                let lon:Double = Double(reqCoOrdinate[1])!
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lon))
                marker.map = mapView
                marker.icon = GMSMarker.markerImage(with: UIColor.darkGray)
                markersArray.append(marker)
            }
        }
    }
    
    func drawRoute() {
        let route = LocationService.shared.overViewPolyLine["points"] as! String
        print(route)
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyLine = GMSPolyline(path: path)
        routePolyLine?.strokeColor = UIColor.black
        routePolyLine?.strokeWidth = 2.0
        routePolyLine?.map = mapView
        let bounds = GMSCoordinateBounds(path: path)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60.0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TRACK_CUSTOMERVC_TO_CHARGER_READINGVC {
            let readingVc = segue.destination as! ChargerReadingVC
            readingVc.vehicleFare = self.vehicleFare
        }
    }

}

extension CustomerTrackVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            //mapView.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
        mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
        mapView.settings.compassButton = true
        
    }
}

