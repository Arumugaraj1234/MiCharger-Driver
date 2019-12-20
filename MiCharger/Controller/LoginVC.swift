//
//  LoginVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-16.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import KOControls

class LoginVC: UIViewController {
    
    //MARK: OUTLETS
    //App Init view outlets
    @IBOutlet weak var instructionLbl: UILabel!
    @IBOutlet weak var laterBtn: RoundedBtn!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    //Login view outlets
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var mobileNoTF: KOTextField!
    @IBOutlet weak var passwordTF: KOTextField!
    
    //Forget Password view outlets
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var forgetMobileNoTF: KOTextField!
    
    //MARK: CONSTANTS
    let webService = WebService.shared
    
    //MARK: VARIABLES
    var isValidToLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        shouldPresentLoadingViewWithText(true, "")
        hideKeyboardWhenTappedAround()
        forgetPasswordView.isHidden = true
        setupAppInitialLoginView()
        getAppInitDetails()
        
    }
    
    @IBAction func onLaterBtnPressed(sender: RoundedBtn) {
        // Skip to the login screen if not logined.
        // Skip to the home screen if logined.
        
        if webService.isUserLoggedIn {
            //Skip to next screen
            performSegue(withIdentifier: LOGINVC_TO_HOMEVC, sender: self)
        }
        else {
            UIView.animate(withDuration: 3.0) {
                self.loginView.isHidden = false
            }
        }
    }
    
    @IBAction func onUpdateBtnPressed(sender: RoundedBtn) {
        // Redirect the user to AppStore screen of the app
    }
    
    @IBAction func onLoginBtnPressed(sender: RoundedBtn) {
        login()
    }
    
    @IBAction func onForgetPasswordBtnPressed(sender: UIButton) {
        UIView.animate(withDuration: 3.0) {
            self.forgetPasswordView.isHidden = false
        }
    }
    
    @IBAction func onSendPasswordBtnPressed(sender: RoundedBtn) {
        view.endEditing(true)
        if checkInternetAvailablity() {
            let mobileNo = forgetMobileNoTF.text!
            var isMobileNoValid = false
            if mobileNo.count > 9 && mobileNo.count < 14 {
                forgetMobileNoTF.error.isShowing = false
                isMobileNoValid = true
            }
            else {
                forgetMobileNoTF.error.isShowing = true
                isMobileNoValid = false
            }
            
            if isMobileNoValid {
                startAnimate(with: "")
                webService.forgetPassword(mobileNo: mobileNo) { (status, message) in
                    if status == 1 {
                        self.stopAnimating()
                        _ = SweetAlert().showAlert("Success", subTitle: message, style: .none, buttonTitle: "OK", action: { (success) in
                            if success {
                                UIView.animate(withDuration: 3.0, animations: {
                                    self.forgetPasswordView.isHidden = true
                                })
                            }
                        })
                    }
                    else {
                        self.stopAnimating()
                        _ = SweetAlert().showAlert("Error aaa", subTitle: message, style: .none)
                    }
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    @IBAction func onBackBtnPressedAtForgetPasswordView(sender: UIButton) {
        UIView.animate(withDuration: 3.0) {
            self.forgetPasswordView.isHidden = true
        }
    }
    
    func getAppInitDetails() {
        if checkInternetAvailablity() {
            webService.getAppInitDetails { (status, msg, data) in
                if status == 1 {
                    guard let appInit = data else {return}
                    // Step 1: Check the verison in local machine
                    // Step 2: If version not updated in local device, Check the flag from webservice
                    // Step 3: If flag is 1, both option will be available to update or skip
                    // Step 4: If flag is 2, only 1 option will be availale of Update the app
                    // Step 5: if version is updated, then check if user logged in or not
                    // Step 6: if not logged in show login view
                    // Step 7: If aleady logged in Skip to home screen
                    
                    let appVersionInMyMachine = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                    var isApplicationToUpdate = false
                    if appVersionInMyMachine! != appInit.newVersion {
                        isApplicationToUpdate = true
                    }
                    if isApplicationToUpdate && appInit.flag != 0 {
                        self.loginView.isHidden = true
                        self.instructionLbl.text = appInit.instruction
                        if appInit.flag == 2 {
                            self.laterBtn.isHidden = true
                        }
                        self.shouldPresentLoadingViewWithText(false, "")
                    }
                    else {
                        if self.webService.isUserLoggedIn {
                           // Skip To Next Screen
                            print("Skip to home screen")
                            self.performSegue(withIdentifier: LOGINVC_TO_HOMEVC, sender: self)
                            self.shouldPresentLoadingViewWithText(false, "")
                        }
                        else {
                            self.loginView.isHidden = false
                            self.shouldPresentLoadingViewWithText(false, "")
                        }
                    }

                }
                else {
                    self.loginView.isHidden = true
                    self.buttonsStackView.isHidden = true
                    self.instructionLbl.text = "Something went wrong. Please try again later"
                    self.shouldPresentLoadingViewWithText(false, "")
                }
            }
        }
        else {
            loginView.isHidden = true
            buttonsStackView.isHidden = true
            instructionLbl.text = NETWORK_ERROR_MSG
            shouldPresentLoadingViewWithText(false, "")
        }
    }
    
    func setupAppInitialLoginView() {
        mobileNoTF.addHideinputAccessoryView()
        mobileNoTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        mobileNoTF.errorInfo.description = "Invalid mobile number"
        mobileNoTF.validation.add(validator: KOFunctionTextValidator(function: { mobileNo -> Bool in
            return mobileNo.count > 9 && mobileNo.count < 14
        }))
        
        passwordTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTF.errorInfo.description = "Password can't be empty"
        passwordTF.validation.add(validator: KOFunctionTextValidator(function: { password -> Bool in
            return password.count > 2
        }))
        
        forgetMobileNoTF.addHideinputAccessoryView()
        forgetMobileNoTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        forgetMobileNoTF.errorInfo.description = "Invalid mobile number"
        forgetMobileNoTF.validation.add(validator: KOFunctionTextValidator(function: { mobileNo -> Bool in
            return mobileNo.count > 9 && mobileNo.count < 14
        }))
    }
    
    func validateForLogin() {
        view.endEditing(true)
        let mobileNo = mobileNoTF.text!
        let password = passwordTF.text!
        var isMobileValid = false
        var isPasswordValid = false
        
        if mobileNo.count > 9 && mobileNo.count < 14 {
            mobileNoTF.error.isShowing = false
            isMobileValid = true
        }
        else {
            mobileNoTF.error.isShowing = true
            isMobileValid = false
        }
        if password.count > 2 {
            passwordTF.error.isShowing = false
            isPasswordValid = true
        }
        else {
            passwordTF.error.isShowing = true
            isPasswordValid = false
        }
        if isMobileValid && isPasswordValid {
            isValidToLogin = true
        }
        else {
            isValidToLogin = false
        }
    }
    
    func login() {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            validateForLogin()
            if isValidToLogin {
                let mobileNo = mobileNoTF.text!
                let password = passwordTF.text!
                
                webService.login(mobileNo: mobileNo, password: password) { (status, message) in
                    if status == 1 {
                        //Skip to home screen
                        self.stopAnimating()
                        LocationService.shared.updateLocationWithTimer()
                        self.performSegue(withIdentifier: LOGINVC_TO_HOMEVC, sender: self)
                    }
                    else {
                        self.stopAnimating()
                        _ = SweetAlert().showAlert("Failed!", subTitle: message, style: .none)
                    }
                }
            }
            else {
                stopAnimating()
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            _ = mobileNoTF.resignFirstResponder()
            _ = passwordTF.becomeFirstResponder()
        }
        if textField.tag == 2 {
            login()
            _ = passwordTF.resignFirstResponder()
        }
        return true
    }
}

