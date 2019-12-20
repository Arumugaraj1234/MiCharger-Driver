//
//  AppDelegate.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-25.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationService = LocationService.shared
    let webService = WebService.shared


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationService.setGoogleApiKeys()
        locationService.authorize()
        if webService.isUserLoggedIn {
            locationService.updateLocationWithTimer()
        }
        return true
    }

    


}

