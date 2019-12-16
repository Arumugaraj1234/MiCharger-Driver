//
//  TextFiledExt.swift
//  E-CarCharger
//
//  Created by MacBook Pro on 2019-11-01.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addHideinputAccessoryView() {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.barTintColor = #colorLiteral(red: 0.7960784314, green: 0.831372549, blue: 0.862745098, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.resignFirstResponder))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 25)!], for: UIControl.State.normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    func setPadding() {
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        
        func textRect(forBounds bounds: CGRect) -> CGRect {
            //return UIEdgeInsetsInsetRect(bounds, padding)
            
            return bounds.inset(by: padding)
        }
        
        func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    }
    
    func setCornerRadius() {
        self.layer.cornerRadius = 5.0
    }
}
