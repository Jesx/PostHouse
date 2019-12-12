//
//  TaskListViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/3.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import PKHUD
import SVProgressHUD

class TaskListViewController: UIViewController {
    
    @IBOutlet var testView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var athensButton: UIButton!
    @IBOutlet weak var phokisButton: UIButton!
    @IBOutlet weak var arkadiaButton: UIButton!
    @IBOutlet weak var spardaButton: UIButton!
    
    var taskList = [TaskList.TaskListData]()
    var taskListStation = [TaskList.TaskListData]()
    
    var station = Station.Athens
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

//        athensButton.centerVertically()
//        phokisButton.centerVertically()
//        arkadiaButton.centerVertically()
//        spardaButton.centerVertically()
        
        athensButton.imageView?.contentMode = .scaleAspectFit
        phokisButton.imageView?.contentMode = .scaleAspectFit
        arkadiaButton.imageView?.contentMode = .scaleAspectFit
        spardaButton.imageView?.contentMode = .scaleAspectFit
        
        athensButton.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllTasks()
    }
    
    func getAllTasks() {
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
        SVProgressHUD.show()
        RunnerData().getAllTasks { (taskList) in
            self.taskList = taskList.data
            self.taskListStation = self.taskList.filter( {$0.start_station_name == self.station.rawValue} )
            DispatchQueue.main.async {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func didTapAthens(_ sender: UIButton) {
        station = .Athens
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 1)
        phokisButton.backgroundColor = UIColor.systemBackground
        arkadiaButton.backgroundColor = UIColor.systemBackground
        spardaButton.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func didTapPhokis(_ sender: UIButton) {
        station = .Phokis
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 1)
        athensButton.backgroundColor = UIColor.systemBackground
        arkadiaButton.backgroundColor = UIColor.systemBackground
        spardaButton.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func didTapAkadia(_ sender: UIButton) {
        station = .Arkadia
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 1)
        athensButton.backgroundColor = UIColor.systemBackground
        phokisButton.backgroundColor = UIColor.systemBackground
        spardaButton.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func didTapSparta(_ sender: UIButton) {
        station = .Sparta
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
        sender.backgroundColor = #colorLiteral(red: 0.6700000167, green: 0.6700000167, blue: 0.6700000167, alpha: 1)
        athensButton.backgroundColor = UIColor.systemBackground
        phokisButton.backgroundColor = UIColor.systemBackground
        arkadiaButton.backgroundColor = UIColor.systemBackground
    }
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListStation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListTableViewCell.self), for: indexPath) as! TaskListTableViewCell
    
        let task = taskListStation[indexPath.row]
        
        if let photoUrl = task.photo_url {
            let url = URL(string: photoUrl)
            cell.itemImageView.kf.setImage(with: url)
        } else {
            cell.itemImageView.image = UIImage(named: "dummy-image")
        }
        
        cell.itemLabel.text = "訂單名稱：\(task.good_name)"
        cell.destinationLabel.text = "目的驛站：\(task.des_station_name)"
        cell.itemStatus.text = "貨品狀態：\(task.status)"
        cell.deliveryFeeLabel.text = "運送費用：\(task.price)"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskListStation[indexPath.row]
        
        if let photoUrl = task.photo_url {
            let url = URL(string: photoUrl)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "dummy-image")
        }
        
        if task.status == "準備中" {
            
            let alert = AlertService().alert(image: imageView.image, itemName: task.good_name, itemLocation: task.start_station_name, destination: task.des_station_name, weight: task.weight) {
                
                RunnerData().confirmTask(shipmentId: task.id) { (taskResponse) in
                    DispatchQueue.main.async {
                        HUD.flash(.label(taskResponse.message), delay: 2)
                    }
                }
            }
            present(alert, animated: true, completion: nil)
            
        } else {
            HUD.flash(.label("只能接「準備中」的單喔！"), delay: 1)
        }
    }
}

extension UIButton {

    func centerVertically(padding: CGFloat = 2.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
            return
        }

        let totalHeight = imageViewSize.height + titleLabelSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: -(totalHeight - imageViewSize.height),
            right: -titleLabelSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - titleLabelSize.height),
            left: -imageViewSize.width,
            bottom: 0.0,
            right: 0.0
        )

        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }

}
