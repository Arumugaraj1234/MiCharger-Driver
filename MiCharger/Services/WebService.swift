//
//  WebService.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-16.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebService: NSObject {
    
    private override init() {}
    static let shared = WebService()
    let userDefaults = UserDefaults.standard
    var isUserLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: USER_LOGGED_IN_KEY)
        }
        set {
            userDefaults.set(newValue, forKey: USER_LOGGED_IN_KEY)
        }
    }
    var userDetails: [String: String] {
        get {
            return userDefaults.value(forKey: USER_DETAILS_KEY) as! [String: String]
        }
        set {
            userDefaults.set(newValue, forKey: USER_DETAILS_KEY)
        }
    }
    var userId: Int {
        get {
            return userDefaults.integer(forKey: USER_ID_KEY)
        }
        set {
            userDefaults.set(newValue, forKey: USER_ID_KEY)
        }
    }
    
    var availableOrderForAcceptOrDecline: OrderReceivedModel?
    var acceptedOrder: AcceptedOrderModel?
    
    func getAppInitDetails(completion: @escaping (_ status: Int, _ message: String, _ data: AppInitModel?) -> Void) {
        
        let params = [
            "Id": 4
        ]
        
        Alamofire.request(URL_TO_GET_APP_INIT_DETAILS, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseStatus = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseStatus == 1 {
                    let responseData = json["ResponseData"]
                    let id = responseData["Id"].intValue
                    let type = responseData["Type"].stringValue
                    let recentVersioinDouble = responseData["Version"].doubleValue
                    let recentVersion = String(recentVersioinDouble)
                    let upgrade = responseData["Upgrade"].intValue
                    let instruction = responseData["Message"].stringValue
                    let appInitModel = AppInitModel(id: id, type: type, newVersion: recentVersion, flag: upgrade, instruction: instruction)
                    completion(responseStatus, responseMessage, appInitModel)
                }
                else {
                    completion(responseStatus, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
    func login(mobileNo: String, password: String, completion: @escaping (_ status: Int, _ message: String) -> Void){
        let params = [
            "Phone": mobileNo,
            "Password": password
        ]
        
        Alamofire.request(URL_TO_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let id = responseData["Id"].intValue
                    let firstName = responseData["FirstName"].stringValue
                    let lastName = responseData["LastName"].stringValue
                    let email = responseData["Email"].stringValue
                    let phone = responseData["Phone"].stringValue
                    
                    self.isUserLoggedIn = true
                    self.userId = id
                    var userDetails = [String: String]()
                    userDetails[FIRST_NAME] = firstName
                    userDetails[LAST_NAME] = lastName
                    userDetails[EMAIL] = email
                    userDetails[MOBILE_NO] = phone
                    self.userDetails = userDetails
                    completion(responseCode, responseMessage)
                }
                else {
                    completion(responseCode, responseMessage)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func forgetPassword(mobileNo: String, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        let params = [
            "Phone": mobileNo
        ]
        
        Alamofire.request(URL_TO_FORGET_PASSWORD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                completion(responseCode, responseMessage)
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
        
    }
    
    func findAnyBookingAvailable(userId: Int, completion: @escaping (_ status: Int, _ message: String, _ data: OrderReceivedModel?) -> Void) {
        let params = [
            "ChargerId": userId
        ]
        
        Alamofire.request(URL_TO_CHECK_ANY_ORDER_AVAILABLE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let orderId = responseData["BookingId"].intValue
                    let vehicleId = responseData["VehileId"].intValue
                    let vehicleName = responseData["VehileName"].stringValue
                    let vehicleImageLink = responseData["VehileImage"].stringValue
                    let customerName = "Test"
                    
                    let orderReceiveModel = OrderReceivedModel(orderId: orderId, vehicleId: vehicleId, vehicleName: vehicleName, vehicleImageLink: vehicleImageLink, customerName: customerName)
                    completion(responseCode, responseMessage, orderReceiveModel)
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
    func autoRejectOfOrder(orderId: Int, userId: Int, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        let params = [
            "BookingId": orderId,
            "ChargerId": userId,
            "Type": 2
        ]
        
        Alamofire.request(URL_TO_AUTO_REJECT_ORDER, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                print(json)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                completion(responseCode, responseMessage)
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func acceptOrDeclineOrder(orderId: Int, userId: Int, type: Int, completion: @escaping (_ status: Int, _ message: String, _ data: AcceptedOrderModel?) -> Void ) {
        let params = [
            "BookingId": orderId,
            "ChargerId": userId,
            "Type": type
        ]
        
        Alamofire.request(URL_TO_ACCEPT_OR_DECLINE_ORDER, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if type == 1 {
                    if responseCode == 1 {
                        let responseData = json["ResponseData"]
                        let orderId = responseData["BookingId"].intValue
                        let vehicleId = responseData["VehileId"].intValue
                        let vehicleName = responseData["VehileName"].stringValue
                        let vehicleImageLink = responseData["VehileImage"].stringValue
                        let customerId = responseData["CustomerId"].intValue
                        let customerName = responseData["CustomerName"].stringValue
                        let customerNo = responseData["CustomerNumber"].stringValue
                        let customerLatitude = responseData["Latitude"].doubleValue
                        let customerLongitude = responseData["Longitude"].doubleValue
                        let acceptedOrderModel = AcceptedOrderModel(orderId: orderId, vehicleId: vehicleId, vehicleName: vehicleName, vehicleImageLink: vehicleImageLink, customerId: customerId, customerName: customerName, customerContactNo: customerNo, customerLatitude: customerLatitude, customerLongitude: customerLongitude)
                        completion(responseCode, responseMessage, acceptedOrderModel)
                    }
                    else {
                        completion(responseCode, responseMessage, nil)
                    }
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
        
    }
    
    func verifyOtpForCharge(orderId: Int, otp: String, chargerId: Int, completion: @escaping (_ status: Int, _ message: String, _ data: VehicleFareModel?) -> Void) {
        let params: [String: Any] = [
            "BookingId": orderId,
            "OTP": otp,
            "ChargerId": chargerId
        ]
        
        Alamofire.request(URL_TO_VERIFY_OTP_FOR_RECHARGE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let vehicleId = responseData["Id"].intValue
                    let vehicleName = responseData["Type"].stringValue
                    let baseFare = responseData["BaseFare"].doubleValue
                    let additionalFare = responseData["AdditionalFare"].doubleValue
                    let farePerMin = responseData["FarePerMin"].doubleValue
                    let vehicleFareModel = VehicleFareModel(id: vehicleId, name: vehicleName, baseFare: baseFare, additionalFare: additionalFare, farePerMin: farePerMin)
                    completion(responseCode, responseMessage, vehicleFareModel)
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
    func startCharging(orderId: Int, userId: Int, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        let params = [
            "BookingId": orderId,
            "ChargerId": userId,
            "TotalSecounds": 0
        ]
        
        Alamofire.request(URL_TO_START_CHARGING, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                completion(responseCode, responseMessage)
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func completeCharging(orderId: Int, userId: Int, totalSeconds: Int, completion: @escaping (_ status: Int, _ message: String, _ data: CompleteOrderFareModel?) -> Void) {
        
        let params = [
            "BookingId": orderId,
            "ChargerId": userId,
            "TotalSecounds": totalSeconds
        ]
        
        Alamofire.request(URL_TO_COMPLETE_CHARGING, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let timeTaken = responseData["TimeTaken"].stringValue
                    let fare = responseData["Fare"].doubleValue
                    let fareModel = CompleteOrderFareModel(totalTime: timeTaken, totalFare: fare)
                    completion(responseCode, responseMessage, fareModel)
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
    func getBookingHistory(orderId: Int, completion: @escaping (_ status: Int, _ message: String, _ data: [HistoryOrderModel]?) -> Void) {
        let params = [
            "ChargerId": orderId
        ]
        
        Alamofire.request(URL_TO_GET_BOOKING_HISTORY, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    var history = [HistoryOrderModel]()
                    let responseData = json["ResponseData"].arrayValue
                    for order in responseData {
                        let orderId = order["BookingId"].intValue
                        let vehicleId = order["VehileId"].intValue
                        let vehicleName = order["VehileName"].stringValue
                        let vehicleImageLink = order["VehileImage"].stringValue
                        let customerId = order["CustomerId"].intValue
                        let customerName = order["CustomerName"].stringValue
                        let customerContactNo = order["CustomerNumber"].stringValue
                        let fare = order["Fare"].doubleValue
                        let status = order["Status"].stringValue
                        let bookedDate = order["Booked"].stringValue
                        let paymentStatus = order["PaymentStatus"].stringValue
                        
                        let historyModel = HistoryOrderModel(orderId: orderId, vehicleId: vehicleId, vehicleName: vehicleName, vehicleImageLink: vehicleImageLink, customerId: customerId, customerName: customerName, customerContactNo: customerContactNo, fare: fare, orderStatus: status, orderDate: bookedDate, paymentStatus: paymentStatus)
                        history.append(historyModel)
                    }
                    completion(responseCode, responseMessage, history)
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
    
    func updateProfile(userId: Int, firstName: String, lastName: String, email: String, phone: String, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        let params: [String: Any] = [
            "ChargerId": userId,
            "FirstName": firstName,
            "LastName": lastName,
            "Email": email,
            "Phone": phone,
            "Password": ""
        ]
        
        Alamofire.request(URL_TO_UPDATE_PROFILE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let fName = responseData["FirstName"].stringValue
                    let lName = responseData["LastName"].stringValue
                    let emailAddress = responseData["Email"].stringValue
                    let mobile = responseData["Phone"].stringValue
                    
                    var userDetails = [String: String]()
                    userDetails[FIRST_NAME] = fName
                    userDetails[LAST_NAME] = lName
                    userDetails[EMAIL] = emailAddress
                    userDetails[MOBILE_NO] = mobile
                    self.userDetails = userDetails
                    
                    completion(responseCode, responseMessage)
                }
                else {
                    completion(responseCode, responseMessage)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func logOut(userId: Int, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        let params = [
            "ChargerId": userId
        ]
        
        Alamofire.request(URL_TO_LOGOUT, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMesage = json["ResponseMessage"].stringValue
                self.userId = 0
                self.isUserLoggedIn = false
                var userDetails = [String: String]()
                userDetails[FIRST_NAME] = ""
                userDetails[LAST_NAME] = ""
                userDetails[EMAIL] = ""
                userDetails[MOBILE_NO] = ""
                self.userDetails = userDetails
                completion(responseCode, responseMesage)
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func updateDriverDutyStatus(userId: Int, dutyStatus: Int, completion: @escaping (_ status: Int, _ message: String) -> Void) {
        // DUTY STATUS: 0 - Offline, 1 - Free
        let params = [
            "ChargerId": userId,
            "Status": dutyStatus
        ]
        
        Alamofire.request(URl_TO_UPDATE_DRIVER_DUTY_STATUS, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                completion(responseCode, responseMessage)
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func getChargerCurrentDutyStatus(userId: Int, completion: @escaping (_ status: Int, _ message: String, _ data: Int?) -> Void) {
        let params = [
            "ChargerId": userId
        ]
        
        Alamofire.request(URL_TO_GET_CURRENT_DUTY_STATUS, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let responseCode = json["ResponseCode"].intValue
                let responseMessage = json["ResponseMessage"].stringValue
                if responseCode == 1 {
                    let responseData = json["ResponseData"]
                    let status = responseData["Id"].intValue
                    completion(responseCode, responseMessage, status)
                }
                else {
                    completion(responseCode, responseMessage, nil)
                }
            }
            else {
                debugPrint(response.error as Any)
                completion(-2, response.error?.localizedDescription ?? "", nil)
            }
        }
    }
    
}


