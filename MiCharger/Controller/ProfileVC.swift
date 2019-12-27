//
//  ProfileVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-21.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

enum DutyStatus: Int {
    case on = 1
    case off = 0
}

class ProfileVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var driverStatusSwitch: UISwitch!
    
    //MARK: CONSTANTS
    let webService = WebService.shared
    var dutyStatus: DutyStatus = .on
    var previousValue = false
    var flag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setInitialSetup()
        getCurrentDutyStatus()
    }
    
    @IBAction func onEditBtnTapped(sender: UIButton) {
        performSegue(withIdentifier: PROFILEVC_TO_UPDATE_PROFILEVC, sender: self)
    }

    @IBAction func onUpdateDriverStatusTapped(_ sender: UISwitch) {
        if checkInternetAvailablity() {
            if dutyStatus == .on {
                updateDriverDutyStatus(dutyStatus: .off)
            }
            else {
                updateDriverDutyStatus(dutyStatus: .on)
            }
        }
        else {
            if flag == 1 {
                flag = 0
                return
            }
            flag = 1
            if dutyStatus == .on {
                self.driverStatusSwitch.setOn(true, animated: false)
                self.dutyStatus = .on
            }
            else {
                self.driverStatusSwitch.setOn(false, animated: false)
                self.dutyStatus = .off
            }
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    @IBAction func onLogOutBtnPressed(_ sender: UIButton) {
        _ = SweetAlert().showAlert("", subTitle: "Are you sure you want to log out?", style: .none, buttonTitle: "Yes", buttonColor: #colorLiteral(red: 0.1689489484, green: 0.4756089449, blue: 0, alpha: 1), otherButtonTitle: "No", action: { (status) in
            if status {
                self.logOut()
            }
        })
    }
    
    func setInitialSetup() {
        let userDetails = webService.userDetails
        let firstName = userDetails[FIRST_NAME] ?? ""
        let lastname = userDetails[LAST_NAME] ?? ""
        let email = userDetails[EMAIL] ?? ""
        let phone = userDetails[MOBILE_NO] ?? ""
        
        nameLbl.text = "Name: \(firstName) \(lastname)"
        emailLbl.text = "Email: \(email)"
        phoneLbl.text = "Mobile No: \(phone)"
        
        if webService.acceptedOrder == nil {
            driverStatusSwitch.isEnabled = true
        }
        else {
            driverStatusSwitch.isEnabled = false
        }
    }
    
    func logOut() {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            webService.logOut(userId: webService.userId) { (status, message) in
                self.stopAnimating()
                if status == 1 {
                    let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVc = main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.present(loginVc, animated: true, completion: nil)
                }
                else {
                    _ = SweetAlert().showAlert("Failed!", subTitle: message, style: .none)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    func updateDriverDutyStatus(dutyStatus: DutyStatus) {
        startAnimate(with: "")
        webService.updateDriverDutyStatus(userId: webService.userId, dutyStatus: dutyStatus.rawValue) { (status, message) in
            self.stopAnimating()
            if status == 1 {
                if dutyStatus == .on {
                    self.driverStatusSwitch.setOn(true, animated: true)
                    self.dutyStatus = .on
                }
                else if dutyStatus == .off {
                    self.driverStatusSwitch.setOn(false, animated: true)
                    self.dutyStatus = .off
                }
            }
            else {
                _ = SweetAlert().showAlert("Failed!", subTitle: message, style: .none)
            }
        }
    }
    
    func getCurrentDutyStatus() {
        webService.getChargerCurrentDutyStatus(userId: webService.userId) { (status, message, data) in
            if status == 1 {
                guard let status = data else {return}
                if status == 0 {
                    self.dutyStatus = .off
                    self.driverStatusSwitch.setOn(false, animated: false)
                }
                else {
                    self.dutyStatus = .on
                    self.driverStatusSwitch.setOn(true, animated: false)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PROFILEVC_TO_UPDATE_PROFILEVC {
            let editVc = segue.destination as! EditProfileVC
            editVc.delegate = self
        }
    }
    

}

extension ProfileVC: ProfileGotUpdatedDelegate {
    func updateProfile() {
        setInitialSetup()
    }
}
