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
let TRACK_CUSTOMERVC_TO_CHARGER_READINGVC = "trackCustomerVcToChargerReadingVc"
let PROFILEVC_TO_UPDATE_PROFILEVC = "profileVcToEditProfileVc"

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
let URL_TO_UPDATE_CHARGER_LOCATION = BASE_URL + "UpdateLocation"
let URL_TO_CHECK_ANY_ORDER_AVAILABLE = BASE_URL + "FindBooking"
let URL_TO_AUTO_REJECT_ORDER = BASE_URL + "AutoReject"
let URL_TO_ACCEPT_OR_DECLINE_ORDER = BASE_URL + "AcceptOrDecline"
let URL_TO_VERIFY_OTP_FOR_RECHARGE = BASE_URL + "VerifyOtp"
let URL_TO_START_CHARGING = BASE_URL + "StartCharging"
let URL_TO_COMPLETE_CHARGING = BASE_URL + "CompleteCharger"
let URL_TO_GET_BOOKING_HISTORY = BASE_URL + "MyBooking"
let URL_TO_UPDATE_PROFILE = BASE_URL + "UpdateProfile"
let URL_TO_LOGOUT = BASE_URL + "Logout"
let URl_TO_UPDATE_DRIVER_DUTY_STATUS = BASE_URL + "UpdateStatus"
let URL_TO_GET_CURRENT_DUTY_STATUS = BASE_URL + "GetDutyStatus"
