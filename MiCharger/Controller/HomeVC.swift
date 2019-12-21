//
//  HomeVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-25.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class HomeVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var orderAcceptView: UIView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var balanceTimeLbl: UILabel!
    
    //MARK: MAP RELATED VARIABLES
    var originMaker: GMSMarker?
    var destinationMarker: GMSMarker?
    var routePolyLine: GMSPolyline?
    var markersArray = [GMSMarker]()
    var wayPointsArray = [String]()
    
    //MARK: VARIABLES
    let locationService = LocationService.shared
    let locationManager = CLLocationManager()
    let webService = WebService.shared
    
    var timer: Timer?
    var timerForBalanceSec: Timer?
    var maxSeconds = 20


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        if let availableOrder = webService.availableOrderForAcceptOrDecline {
            orderAcceptView.isHidden = false
            customerNameLbl.text = availableOrder.customerName
            vehicleNameLbl.text = availableOrder.vehicleName
            vehicleImage.downloadedFrom(link: availableOrder.vehicleImageLink)
            timerForBalanceSec = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBalanceTimeLbl), userInfo: nil, repeats: true)
        }
        else {
            orderAcceptView.isHidden = true
            checkForAnyOrderWithTimer()
        }

        //showCustomerLocation()
        
    }
    
    @IBAction func onAcceptBtnTapped(sender: UIButton) {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            guard let availableOrder = webService.availableOrderForAcceptOrDecline else {return}
            webService.acceptOrDeclineOrder(orderId: availableOrder.orderId, userId: webService.userId, type: 1) { (status, message, data) in
                if status == 1 {
                    self.stopAnimating()
                    self.timerForBalanceSec?.invalidate()
                    self.timerForBalanceSec = nil
                    
                    guard let acceptOrder = data else {return}
                    
                    self.webService.availableOrderForAcceptOrDecline = nil
                    self.orderAcceptView.isHidden = true
                    
                    self.webService.acceptedOrder = acceptOrder
                    self.performSegue(withIdentifier: HOMEVC_TO_CUSTOMER_TRACKVC, sender: self)
                }
                else {
                    self.stopAnimating()
                    _ = SweetAlert().showAlert("Oops!", subTitle: message, style: .none)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
        
    }
    
    @IBAction func onDeclineBtnPressed(sender: UIButton) {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            guard let availableOrder = webService.availableOrderForAcceptOrDecline else {return}
            webService.acceptOrDeclineOrder(orderId: availableOrder.orderId, userId: webService.userId, type: 2) { (status, message, data) in
                if status == 1 {
                    self.stopAnimating()
                    self.timerForBalanceSec?.invalidate()
                    self.timerForBalanceSec = nil
                    
                    self.webService.availableOrderForAcceptOrDecline = nil
                    self.orderAcceptView.isHidden = true
                    self.checkForAnyOrderWithTimer()
                }
                else {
                    self.stopAnimating()
                    _ = SweetAlert().showAlert("Oops!", subTitle: message, style: .none)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    func checkForAnyOrderWithTimer() {
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(checkForAnyOrderAvailable), userInfo: nil, repeats: true)
    }
    
    @objc
    func checkForAnyOrderAvailable() {
        webService.findAnyBookingAvailable(userId: webService.userId) { (status, message, data) in
            if status == 1 {
                self.timer?.invalidate()
                self.timer = nil
                guard let orderModel = data else {return}
                self.webService.availableOrderForAcceptOrDecline = orderModel
                //homeTabBarController
                let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeTabBarCon = main.instantiateViewController(withIdentifier: "homeTabBarController") as! UITabBarController
                self.present(homeTabBarCon, animated: true, completion: nil)
            }
            else {
                print("No Order found")
            }
        }
    }
    
    @objc
    func updateBalanceTimeLbl() {
        print(maxSeconds)
        if maxSeconds > 0 {
            balanceTimeLbl.text = String(maxSeconds)
            maxSeconds = maxSeconds - 1
        }
        else {
            guard let availableOrder = webService.availableOrderForAcceptOrDecline else {return}
            webService.autoRejectOfOrder(orderId: availableOrder.orderId, userId: webService.userId) { (status, message) in
                if status == 1 {
                    self.webService.availableOrderForAcceptOrDecline = nil
                    print("Available order got Auto-Cancelled")
                    self.orderAcceptView.isHidden = true
                    self.checkForAnyOrderWithTimer()
                }
            }
            self.timerForBalanceSec?.invalidate()
            self.timerForBalanceSec = nil
        }
    }

}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
        mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
        mapView.settings.compassButton = true

    }
}

