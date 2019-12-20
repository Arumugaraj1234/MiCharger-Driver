//
//  CompleteOrderFareModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-20.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class CompleteOrderFareModel {
    var totalTime: String
    var totalFare: Double
    
    init(totalTime: String, totalFare: Double) {
        self.totalTime = totalTime
        self.totalFare = totalFare
    }
}
