//
//  RoundedBtn.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-28.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }

}
