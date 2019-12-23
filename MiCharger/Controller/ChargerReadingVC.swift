//
//  ChargerReadingVC.swift
//  MiCharger
//
//  Created by MacBook Pro on 2019-12-19.
//  Copyright © 2019 Peach. All rights reserved.
//

import UIKit

enum ChargingStatus: String {
    case start = "start"
    case pause = "pause"
    case stop = "stop"
    case initial = "initial"
}

class ChargerReadingVC: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var startChageBtn: UIButton!
    @IBOutlet weak var pauseCompleteBtnStackView: UIStackView!
    @IBOutlet weak var pauseChargeBtn: UIButton!
    @IBOutlet weak var stopChargeBtn: UIButton!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: CONSTANTS
    let webService = WebService.shared
    let startEnabledImg = UIImage(named: "playIcon")!
    let startDisbledImg = UIImage(named: "playDisableIcon")!
    let pauseEnabledImg = UIImage(named: "pauseIcon")!
    let pauseDisabledImg = UIImage(named: "pauseDisableIcon")!
    let stopEnabledImg = UIImage(named: "stopIcon")!
    let stopDisabledImg = UIImage(named: "stopDisableIcon")!
    
    //MARK: VARIABLES
    var vehicleFare: VehicleFareModel!
    var acceptedOrder: AcceptedOrderModel!
    var timer: Timer?
    var totalSeconds = 0
    var totalFare: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if let accOrder = webService.acceptedOrder {
            acceptedOrder = accOrder
        }
        //pauseCompleteBtnStackView.isHidden = true
        setBtnStatus(status: .initial)
        setCompletBtnStatus(enable: false)
        timeLbl.text = "00:00:00"
        amountLbl.text = "$0.00"
    }
    
    @IBAction func onStartChargeBtnPressed(sender: UIButton) {
        if checkInternetAvailablity() {
            setBtnStatus(status: .start)
            startAnimate(with: "")
            webService.startCharging(orderId: acceptedOrder.orderId, userId: webService.userId) { (status, message) in
                if status == 1 {
                    self.backBtn.isEnabled = false
                    self.stopAnimating()
                    self.startTimer()
                }
                else {
                    self.stopAnimating()
                    self.setBtnStatus(status: .initial)
                }
            }
        }
        else {
            _ = SweetAlert().showAlert("Network Error", subTitle: NETWORK_ERROR_MSG, style: .none)
        }
    }
    
    @IBAction func onpauseChargeBtnPressed(sender: UIButton) {
        setBtnStatus(status: .pause)
//        startChageBtn.isHidden = false
//        pauseCompleteBtnStackView.isHidden = false
//        pauseChargeBtn.isHidden = true
        stopTimer()
    }
    
    @IBAction func onStopBtnPressed(sender: UIButton) {
        stopTimer()
        if checkInternetAvailablity() {
            startAnimate(with: "")
            webService.completeCharging(orderId: acceptedOrder.orderId, userId: webService.userId, totalSeconds: self.totalSeconds) { (status, message, data) in
                if status == 1 {
                    self.stopAnimating()
                    self.setBtnStatus(status: .stop)
                    guard let fareModel = data else {return}
                    print("IOS Fare: \(self.totalFare), Server Fare: \(fareModel.totalFare)")
                    self.webService.acceptedOrder = nil
                    self.setCompletBtnStatus(enable: true)
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
    
    @IBAction func onCompleteChargeBtnPressed(sender: UIButton) {
        let main:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = main.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
        present(historyVC, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtnPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func startTimer() {
//        startChageBtn.isHidden = true
//        pauseChargeBtn.isHidden = false
//        pauseCompleteBtnStackView.isHidden = false
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerDetails), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc
    func updateTimerDetails() {
        totalSeconds = totalSeconds + 1
        setSecondsInHourFormat(totalSecs: totalSeconds)
    }
    
    func setSecondsInHourFormat(totalSecs: Int) {
        let hour = ( totalSecs / 3600 ) % 3600
        let minutes = (( totalSecs % 3600 ) / 60 ) % 60
        let seconds = ( totalSecs % 3600 ) % 60
        
        let hourVal = String(format: "%02d", hour)
        let minutVal = String(format: "%02d", minutes)
        let secVal = String(format: "%02d", seconds)
        
        timeLbl.text = "\(hourVal):\(minutVal):\(secVal)"
        
        let totalSecondsInMin = ( Double(totalSecs) / 60.0 )
        let fareForCharging = totalSecondsInMin * vehicleFare.farePerMin
        let totalFare = vehicleFare.baseFare + vehicleFare.additionalFare + fareForCharging
        self.totalFare = totalFare
        
        let rupee = "\u{20B9}"
        amountLbl.text = rupee + String(format:"%.2f", totalFare)
    }
    
    func setStartBtnStatus(enable: Bool) {
        startChageBtn.isEnabled = enable
        if enable {
            startChageBtn.setImage(startEnabledImg, for: .normal)
        }
        else {
            startChageBtn.setImage(startDisbledImg, for: .normal)
        }
    }
    
    func setPauseBtnStatus(enable: Bool) {
        pauseChargeBtn.isEnabled = enable
        if enable {
            pauseChargeBtn.setImage(pauseEnabledImg, for: .normal)
        }
        else {
            pauseChargeBtn.setImage(pauseDisabledImg, for: .normal)
        }
    }
    
    func setStopBtnStatus(enable: Bool) {
        stopChargeBtn.isEnabled = enable
        if enable {
            stopChargeBtn.setImage(stopEnabledImg, for: .normal)
        }
        else {
            stopChargeBtn.setImage(stopDisabledImg, for: .normal)
        }
    }
    
    func setBtnStatus(status: ChargingStatus) {
        if status == .start {
            setStartBtnStatus(enable: false)
            setPauseBtnStatus(enable: true)
            setStopBtnStatus(enable: true)
        }
        else if status == .pause {
            setStartBtnStatus(enable: true)
            setPauseBtnStatus(enable: false)
            setStopBtnStatus(enable: true)
        }
        else if status == .stop {
            setStartBtnStatus(enable: false)
            setPauseBtnStatus(enable: false)
            setStopBtnStatus(enable: false)
        }
        else if status == .initial {
            setStartBtnStatus(enable: true)
            setPauseBtnStatus(enable: false)
            setStopBtnStatus(enable: false)
        }
    }
    
    func setCompletBtnStatus(enable: Bool) {
        completeBtn.isEnabled = enable
        if enable {
            completeBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else {
            completeBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }


}
