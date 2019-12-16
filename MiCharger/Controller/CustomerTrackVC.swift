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

class CustomerTrackVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK: VARIABLES
    let locationService = LocationService.shared
    let locationManager = CLLocationManager()
    
    var originMaker: GMSMarker?
    var destinationMarker: GMSMarker?
    var routePolyLine: GMSPolyline?
    var markersArray = [GMSMarker]()
    var wayPointsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        showCustomerLocation()
    }
    
    @IBAction func onBackBtnPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func showCustomerLocation() {
        let myLocation = CLLocationCoordinate2DMake(self.locationService.myCurrentLatitude, self.locationService.myCurrentLongitude)
        let chargerLocation = CLLocationCoordinate2DMake(13.272733, 80.265059)
        LocationService.shared.getDirectionsFromgeoCode(originLat: myLocation.latitude, originLon: myLocation.longitude, destinalat: chargerLocation.latitude, destLon: chargerLocation.longitude, wayPoints: [], travelMode: "driving" as AnyObject) { (success) in
            if success {
                DispatchQueue.main.async {
                    print("Poly Line Success")
                    self.configureMapAndMarkersForRoute(chargerCoOrdinates: chargerLocation)
                    self.drawRoute()
                }
            }
        }
    }
    
    func configureMapAndMarkersForRoute(chargerCoOrdinates: CLLocationCoordinate2D) {
        //let myLocatiion = CLLocationCoordinate2DMake(13.073383, 80.260889)
        let myLocatiion = CLLocationCoordinate2DMake(locationService.myCurrentLatitude, locationService.myCurrentLongitude)
        mapView.camera = GMSCameraPosition.camera(withTarget: myLocatiion, zoom: 15.0)
        
        originMaker = GMSMarker(position: myLocatiion)
        originMaker?.map = self.mapView
        originMaker?.icon = UIImage(named: "chargerIcon")
        //originMaker?.title = AuthService.instance.originAddress
        originMaker?.snippet = "Charger"
        self.mapView.selectedMarker = originMaker
        
        //let chargerLocation = CLLocationCoordinate2DMake(13.078519, 80.261002)
        let chargerLocation = chargerCoOrdinates
        destinationMarker = GMSMarker(position: chargerLocation)
        destinationMarker?.map = self.mapView
        destinationMarker?.icon = UIImage(named: "trackIcon")
        //destinationMarker?.title = AuthService.instance.destinationAddress
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
        //self.pathToCentre = path
        let bounds = GMSCoordinateBounds(path: path)
        //mapView.animate(with: GMSCameraUpdate.fit(bounds))
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60.0))
        //self.animateFromToContainerView(shoulShow: false)
    }

}

extension CustomerTrackVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
        //mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
        mapView.settings.compassButton = true
        
    }
}

