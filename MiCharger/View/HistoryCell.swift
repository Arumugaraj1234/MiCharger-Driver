//
//  HistoryCell.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-21.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var bookedDateLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var totalFareLbl: UILabel!
    @IBOutlet weak var paymentStatusImg: UIImageView!

    func configureCell(model: HistoryOrderModel) {
        vehicleImg.downloadedFrom(link: model.vehicleImageLink)
        vehicleNameLbl.text = model.vehicleName
        bookedDateLbl.text = model.orderDate
        orderNoLbl.text = "OrderNo: \(model.orderId)"
        customerNameLbl.text = model.customerName
        let rupee = "\u{20B9}"
        totalFareLbl.text = rupee + String(format:"%.2f", model.fare)
        
        if model.paymentStatus == "Unpaid" {
            paymentStatusImg.image = UIImage(named: "unpaidIcon")
        }
        else {
            paymentStatusImg.image = UIImage(named: "paidIcon")
        }
    }
}
