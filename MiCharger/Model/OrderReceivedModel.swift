//
//  OrderReceivedModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-17.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class OrderReceivedModel {
    var orderId: Int
    var vehicleId: Int
    var vehicleName: String
    var vehicleImageLink: String
    var customerName: String
    
    init(orderId: Int, vehicleId: Int, vehicleName: String, vehicleImageLink: String, customerName: String) {
        self.orderId = orderId
        self.vehicleId = vehicleId
        self.vehicleName = vehicleName
        self.vehicleImageLink = vehicleImageLink
        self.customerName = customerName
    }
}
