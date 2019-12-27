//
//  MessageService.swift
//  E-CarCharger
//
//  Created by MacBook Pro on 2019-12-27.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit
import MessageUI

class MessageService: NSObject {
    
    private override init() {}
    static let shared = MessageService()
    
    func displayMessageInterface(vc: UIViewController, mobileNo: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [mobileNo]
        composeVC.body = ""
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            vc.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
}

extension MessageService: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
