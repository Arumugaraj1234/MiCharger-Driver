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
                completion(-2, response.error as! String, nil)
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
                completion(-2, response.error as! String)
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
                completion(-2, response.error as! String)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
}
