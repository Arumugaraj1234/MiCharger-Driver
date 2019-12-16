//
//  Constants.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-25.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation


//MARK: GOOGLE MAP URL CONSTANTS
let GOOGLE_URL_FOR_GEOCODING =  "https://maps.googleapis.com/maps/api/geocode/json?"
let GOOGLE_URL_FOR_DIRECTIONS = "https://maps.googleapis.com/maps/api/directions/json?"
let GOOGLE_URL_FOR_ADDRESS = "https://maps.googleapis.com/maps/api/geocode/json?"


//MARK: SEGUE IDENTIFIER CONSTANTS
let HOMEVC_TO_CUSTOMER_TRACKVC = "HomeVcToCustomerTrackVc"
let LOGINVC_TO_HOMEVC = "loginVcToHomeVc"

//MARK: HEADER
let HEADER = ["Content-Type" : "application/Json"]

//MARK: USER DEFAULTS KEY
let USER_LOGGED_IN_KEY = "isUserLoggedIn"
let USER_DETAILS_KEY = "userDetails"
let USER_ID_KEY = "userId"

//MARK: USER DETAILS DICTIONARY KEYS
let FIRST_NAME = "firstName"
let LAST_NAME = "lastName"
let EMAIL = "email"
let MOBILE_NO = "mobileNo"

let NETWORK_ERROR_MSG = "Seems to be Offline. Please connect to the internet and try again"

//MARK: URL CONSTANTS
let BASE_URL = "http://101.53.153.54:80/ElectricCharger/WebService/api/Charger/"
let URL_TO_GET_APP_INIT_DETAILS = BASE_URL + "AppInit"
let URL_TO_LOGIN = BASE_URL + "Login"
let URL_TO_FORGET_PASSWORD = BASE_URL + "ForgotLogin"
