//
//  BookingHistoryVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-11-25.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

class BookingHistoryVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: CONSTANTS
    let webService = WebService.shared
    
    //MARK: VARIABLES
    var orders = [HistoryOrderModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getHistory()
    }

    func getHistory() {
        if checkInternetAvailablity() {
            startAnimate(with: "")
            webService.getBookingHistory(orderId: webService.userId) { (status, message, data) in
                if status == 1 {
                    self.stopAnimating()
                    guard let totalOrders = data else {return}
                    self.orders = totalOrders
                    if totalOrders.count > 0 {
                        self.tableView.reloadData()
                    }
                    else {
                        _ = SweetAlert().showAlert("No orders found", subTitle: message, style: .none)
                    }
                }
                else {
                    self.stopAnimating()
                    _ = SweetAlert().showAlert("Error", subTitle: message, style: .none)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }

}

extension BookingHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {return UITableViewCell()}
        let order = orders[indexPath.row]
        cell.configureCell(model: order)
        return cell
    }
}

