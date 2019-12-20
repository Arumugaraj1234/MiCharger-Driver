//
//  VehicleFareModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-20.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class VehicleFareModel {
    var id: Int
    var name: String
    var baseFare: Double
    var additionalFare: Double
    var farePerMin: Double
    
    init(id: Int, name: String, baseFare: Double, additionalFare: Double, farePerMin: Double) {
        self.id = id
        self.name = name
        self.baseFare = baseFare
        self.additionalFare = additionalFare
        self.farePerMin = farePerMin
    }
}
