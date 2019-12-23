//
//  EditProfileVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-21.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import KOControls

protocol ProfileGotUpdatedDelegate {
    func updateProfile()
}

class EditProfileVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var firstNameTF: KOTextField!
    @IBOutlet weak var lastNameTF: KOTextField!
    @IBOutlet weak var emailTF: KOTextField!
    @IBOutlet weak var phoneTF: KOTextField!
    @IBOutlet weak var passwordTF: KOTextField!
    
    //MARK: CONSTANTS
    let webService = WebService.shared
    var isValidToUpdate = false
    var delegate: ProfileGotUpdatedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setInitialView()
    }
    
    @IBAction func onBackBtnPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUpdateBtnPressed(sender: UIButton) {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            let firstName = firstNameTF.text!
            let lastName = lastNameTF.text!
            let email = emailTF.text!
            let phone = phoneTF.text!
            webService.updateProfile(userId: webService.userId, firstName: firstName, lastName: lastName, email: email, phone: phone) { (status, message) in
                self.stopAnimating()
                if status == 1 {
                    self.delegate?.updateProfile()
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    _ = SweetAlert().showAlert("Oops!", subTitle: message, style: .none)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    func setInitialView() {
        let userDetails = webService.userDetails
        let firstName = userDetails[FIRST_NAME] ?? ""
        let lastname = userDetails[LAST_NAME] ?? ""
        let email = userDetails[EMAIL] ?? ""
        let phone = userDetails[MOBILE_NO] ?? ""
        
        firstNameTF.text = firstName
        lastNameTF.text = lastname
        emailTF.text = email
        phoneTF.text = phone
        
        firstNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        firstNameTF.errorInfo.description = "Invalid first name"
        firstNameTF.validation.add(validator: KOFunctionTextValidator(function: { fName -> Bool in
            return fName.count > 0
        }))
        
        lastNameTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        lastNameTF.errorInfo.description = "Invalid last name"
        lastNameTF.validation.add(validator: KOFunctionTextValidator(function: { lName -> Bool in
            return lName.count > 0
        }))
        
        emailTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        emailTF.errorInfo.description = "Invalid Email Address"
        emailTF.validation.add(validator: KORegexTextValidator.mailValidator)
        
        phoneTF.addHideinputAccessoryView()
        phoneTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        phoneTF.errorInfo.description = "Invalid phone number"
        phoneTF.validation.add(validator: KOFunctionTextValidator(function: { phone -> Bool in
            return phone.count > 9 && phone.count < 14
        }))
        
        passwordTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        passwordTF.errorInfo.description = "Invalid password"
        passwordTF.validation.add(validator: KOFunctionTextValidator(function: { pass -> Bool in
            return pass.count > 2
        }))
    }
    
    func validateForUpdate() {
        let firstName = firstNameTF.text!
        let lastName = lastNameTF.text!
        let email = emailTF.text!
        let phone = phoneTF.text!
        
        var isFirstNameValid = true
        var isLastNameValid = true
        var isEmailValid = true
        var isPhoneValid = true
        
        if firstName.count < 1 {
            isFirstNameValid = false
            firstNameTF.error.isShowing = true
        }
        
        if lastName.count < 1 {
            isLastNameValid = false
            lastNameTF.error.isShowing = true
        }
        
        if email == "" {
            isEmailValid = false
            emailTF.error.isShowing = true
        }
        else {
            if isValidEmail(testStr: email) {
                isEmailValid = true
                emailTF.error.isShowing = false
            }
            else {
                isEmailValid = false
                emailTF.error.isShowing = true
            }
        }
        
        if phone == "" {
            isPhoneValid = false
            passwordTF.error.isShowing = true
        }
        else {
            if phone.count > 9 && phone.count < 14 {
                isPhoneValid = true
                passwordTF.error.isShowing = false
            }
            else {
                isPhoneValid = false
                passwordTF.error.isShowing = true
            }
        }
        
        if isFirstNameValid && isLastNameValid && isEmailValid && isPhoneValid {
            isValidToUpdate = true
        }
        else {
            isValidToUpdate = false
        }
        
    }

}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            _ = firstNameTF.resignFirstResponder()
            _ = lastNameTF.becomeFirstResponder()
        case 2:
            _ = lastNameTF.resignFirstResponder()
            _ = emailTF.becomeFirstResponder()
        case 3:
            _ = emailTF.resignFirstResponder()
            _ = phoneTF.becomeFirstResponder()
        default:
            return true
        }
        return true
    }
}
