//
//  LocationService.swift
//  E-CarCharger
//
//  Created by MacBook Pro on 2019-10-31.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationService: NSObject {
    
    private override init() {}
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    //Variables for Route map
    var selectedRoute: [String: AnyObject]!
    var overViewPolyLine: [String: AnyObject]!
    var myCurrentLatitude: CLLocationDegrees = 0
    var myCurrentLongitude: CLLocationDegrees = 0
    var index = 0
    
    func setGoogleApiKeys() {
        GMSServices.provideAPIKey("AIzaSyDUgw31MfDV88qEnxUqInF8VVElUAjqgpg")
        GMSPlacesClient.provideAPIKey("AIzaSyDUgw31MfDV88qEnxUqInF8VVElUAjqgpg")
    }
    
    func authorize() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    

    
    func getDirectionsFromgeoCode(originLat: CLLocationDegrees!,originLon: CLLocationDegrees!, destinalat: Double!, destLon: Double!, wayPoints: [String]!, travelMode: AnyObject!, completion: @escaping (Bool) -> Void) {
        var directionURLString = "\(GOOGLE_URL_FOR_DIRECTIONS)origin=\(originLat!),\(originLon!)&destination=\(destinalat!),\(destLon!)&mode=driving&key=AIzaSyDUgw31MfDV88qEnxUqInF8VVElUAjqgpg"
        var reqDirecttionURL = "\(GOOGLE_URL_FOR_DIRECTIONS)origin=\(originLat ?? 0.0)&destination=\(destinalat ?? 0.0)&mode=driving"
        if wayPoints.count > 0 {
            reqDirecttionURL += "&waypoints=optimize:true"
            for waypoint in wayPoints {
                reqDirecttionURL += "|" + waypoint
            }
            directionURLString = reqDirecttionURL + "&key=AIzaSyDUgw31MfDV88qEnxUqInF8VVElUAjqgpg"
            
        }
        directionURLString = directionURLString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        let directionURL = NSURL(string: directionURLString)
        let request = NSMutableURLRequest(url:directionURL as URL!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil
            {
                completion(false)
                print("error=\(error!)")
                return
            }
            else {
                print("data", data!)
                do{
                    let resultJson = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let status = resultJson!["status"] as! String
                    if status == "OK" {
                        let result = resultJson!["routes"] as! [[String: AnyObject]]
                        self.selectedRoute = result[0]
                        self.overViewPolyLine = self.selectedRoute["overview_polyline"] as! [String: AnyObject]
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                catch{
                    completion(false)
                }
            }
            
        }
        task.resume()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Get Locations")
        index = index + 1
        let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        let location: CLLocation = locations.last ?? defaultLocation
        myCurrentLatitude = location.coordinate.latitude
        myCurrentLongitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in Getting Location: \(error)")
        //locationManager.stopUpdatingLocation()
    }
}
