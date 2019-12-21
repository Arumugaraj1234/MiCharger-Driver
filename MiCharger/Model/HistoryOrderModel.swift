//
//  HistoryOrderModel.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-21.
//  Copyright © 2019 Peach. All rights reserved.
//

import Foundation

class HistoryOrderModel {
    var orderId: Int
    var vehicleId: Int
    var vehicleName: String
    var vehicleImageLink: String
    var customerId: Int
    var customerName: String
    var customerContactNo: String
    var fare: Double
    var orderStatus: String
    var orderDate: String
    var paymentStatus: String
    
    init(orderId: Int, vehicleId: Int, vehicleName: String, vehicleImageLink: String, customerId: Int, customerName: String, customerContactNo: String, fare: Double, orderStatus: String, orderDate: String, paymentStatus: String) {
        self.orderId = orderId
        self.vehicleId = vehicleId
        self.vehicleName = vehicleName
        self.vehicleImageLink = vehicleImageLink
        self.customerId = customerId
        self.customerName = customerName
        self.customerContactNo = customerContactNo
        self.fare = fare
        self.orderStatus = orderStatus
        self.orderDate = orderDate
        self.paymentStatus = paymentStatus
    }
}
