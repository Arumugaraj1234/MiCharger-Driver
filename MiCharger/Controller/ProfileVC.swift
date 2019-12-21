//
//  ProfileVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-21.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    //MARK: CONSTANTS
    let webService = WebService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

       setInitialSetup()
    }
    
    @IBAction func onEditBtnTapped(sender: UIButton) {
        performSegue(withIdentifier: PROFILEVC_TO_UPDATE_PROFILEVC, sender: self)
    }

    @IBAction func onUpdateDriverStatusTapped(_ sender: UISwitch) {
        if sender.isOn {
            print("SET DRIVER STATUS AS ON")
        }
        else {
            print("SET DRIVER STATUS AS OFF")
        }
    }
    
    @IBAction func onLogOutBtnPressed(_ sender: UIButton) {
        
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
