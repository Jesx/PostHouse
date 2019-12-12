//
//  TaskInfoViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/5.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class TaskInfoViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
  
    @IBOutlet weak var mapImageView: UIImageView!
    
    var shipmentId: Int!
    var status: String!
    
    var startStation: String!
    var destinationStation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTask()
    }
    
    func initStatus() {
        itemImageView.image = UIImage(named: "dummy-image")
        itemNameLabel.text = "訂單名稱：無資料"
        startLabel.text = "起始驛站：無資料"
        destinationLabel.text = "目的驛站：無資料"
        statusLabel.text = "狀態：無資料"
        incomeLabel.text = "本單收入：無資料"
        mapImageView.image = UIImage(named: "map")
    }
    
    func getTask() {
    
        RunnerData().getTask { (myTask) in
            
            DispatchQueue.main.async {
                if myTask.message != nil {
                    self.initStatus()
                } else {
                    self.shipmentId = myTask.id!
                    self.status = myTask.status!
                    self.startStation = myTask.start_station_name!
                    self.destinationStation = myTask.des_station_name!
                    
                    if let photoUrl = myTask.photo_url {
                        let url = URL(string: photoUrl)
                        self.itemImageView.kf.setImage(with: url)
                    } else {
                        self.itemImageView.image = UIImage(named: "dummy-image")
                    }
                    
                    self.itemNameLabel.text = "訂單名稱：\(myTask.good_name!)"
                    self.startLabel.text = "起始驛站：\(myTask.start_station_name!)"
                    self.destinationLabel.text = "目的驛站：\(myTask.des_station_name!)"
                    self.statusLabel.text = "狀態：\(myTask.status!)"
                    self.incomeLabel.text = "本單收入：\(myTask.price!)"
                    
                    switch self.destinationStation {
                    case "雅典":
                        self.mapImageView.image = UIImage(named: "map-athens")
                    case "菲基斯":
                        self.mapImageView.image = UIImage(named: "map-phokis")
                    case "阿卡迪亞":
                        self.mapImageView.image = UIImage(named: "map-arkadia")
                    case "斯巴達":
                        self.mapImageView.image = UIImage(named: "map-sparta")
                    default:
                        self.mapImageView.image = UIImage(named: "map")
                    }
                    
                }
            }
            
        }
    }
    @IBAction func didTapRefresh(_ sender: UIBarButtonItem) {
        getTask()
    }
    
    @IBAction func didTapQR(_ sender: UIButton) {
        let qrScannerVC = QRScannerViewController()
        qrScannerVC.modalPresentationStyle = .fullScreen
        qrScannerVC.delegate = self
        if let status = status {
            if status == "準備中" {
                qrScannerVC.stationHint = "請掃描 \(self.startStation!) QR Code"
            } else {
                qrScannerVC.stationHint = "請掃描 \(self.destinationStation!) QR Code"
            }
        }
        present(qrScannerVC, animated: true, completion: nil)
    }
    @IBAction func didTapInfo(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: "回報訂單的狀況，我...", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "出了車禍要去醫院", style: .default) { (_) in
            self.cancelTask(shipmentId: self.shipmentId)
        }
        let action2 = UIAlertAction(title: "貨物被山賊劫走", style: .default) { (_) in
            self.cancelTask(shipmentId: self.shipmentId)
        }
        let action3 = UIAlertAction(title: "貨物被豆芽咬爛", style: .default) { (_) in
            self.cancelTask(shipmentId: self.shipmentId)
        }
        let action4 = UIAlertAction(title: "其他", style: .default) { (_) in
            self.cancelTask(shipmentId: self.shipmentId)
        }
        
        let cancel = UIAlertAction(title: "什麼都不做", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func cancelTask(shipmentId: Int?) {
        
        if let shipmentId = shipmentId {
            RunnerData().cancelTask(shipmentId: shipmentId) { (response) in
                
                DispatchQueue.main.async {
                    if response.message == "已註銷" {
                        HUD.flash(.labeledSuccess(title: "任務回報", subtitle: response.message), delay: 1)
                        self.initStatus()
                    } else {
                        HUD.flash(.labeledError(title: "任務回報", subtitle: response.message), delay: 1)
                    }
                }
            }
            
        } else {
            HUD.flash(.labeledError(title: "請確認", subtitle: "正在運送貨品才能回報貨品狀況"), delay: 2)
        }
    }
    
    @IBAction func didTapPhoneCall(_ sender: UIBarButtonItem) {
        guard let number = URL(string: "tel://119") else { return }
        UIApplication.shared.open(number)
    }
    
    func checkIn(startStation: String) {
        RunnerData().checkIn(startStation: startStation) { (response) in
            DispatchQueue.main.async {
                HUD.flash(.label(response.message), delay: 2)
                self.getTask()
            }
        }
    }
    
    func checkOut(destination: String) {
        RunnerData().checkOut(destinationStation: destination) { (response) in
            DispatchQueue.main.async {
                HUD.flash(.label(response.message), delay: 2)
                if response.message == "此段運送結束" {
                    self.initStatus()
                }
            }
        }
    }
    
}

extension TaskInfoViewController: qrScannerDelegate {
    func getQRString(code: String) {
        
        if let status = status {
            if status == "準備中" {
                checkIn(startStation: code)
            } else {
                checkOut(destination: code)
            }
        }
    }
}

