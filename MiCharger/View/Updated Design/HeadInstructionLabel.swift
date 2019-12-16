//
//  HeadInstructionLabel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-16.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

@IBDesignable
class HeadInstructionLabel: UILabel {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.textColor = UIColor.black
        self.font = UIFont(name: "FuturaCondensed-Medium", size: 18.0)
    }

}
