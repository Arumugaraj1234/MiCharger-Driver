//
//  AcceptedOrderModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-19.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class AcceptedOrderModel {
    var orderId: Int
    var vehicleId: Int
    var vehicleName: String
    var vehicleImageLink: String
    var customerId: Int
    var customerName: String
    var customerContactNo: String
    var customerLatitude: Double
    var customerLongitude: Double
    
    init(orderId: Int, vehicleId: Int, vehicleName: String, vehicleImageLink: String, customerId: Int, customerName: String, customerContactNo: String, customerLatitude: Double, customerLongitude: Double) {
        self.orderId = orderId
        self.vehicleId = vehicleId
        self.vehicleName = vehicleName
        self.vehicleImageLink = vehicleImageLink
        self.customerId = customerId
        self.customerName = customerName
        self.customerContactNo = customerContactNo
        self.customerLatitude = customerLatitude
        self.customerLongitude = customerLongitude
    }
}
