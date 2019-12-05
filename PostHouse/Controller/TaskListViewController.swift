//
//  TaskListViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/3.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var athensButton: UIButton!
    @IBOutlet weak var phokisButton: UIButton!
    @IBOutlet weak var arkadiaButton: UIButton!
    @IBOutlet weak var spardaButton: UIButton!
    
    var taskList = [TaskList.ListData]()
    var taskListStation = [TaskList.ListData]()
    
    var station = Station.Athens
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

        athensButton.centerVertically()
        phokisButton.centerVertically()
        arkadiaButton.centerVertically()
        spardaButton.centerVertically()
        
        athensButton.imageView?.contentMode = .scaleAspectFit
        phokisButton.imageView?.contentMode = .scaleAspectFit
        arkadiaButton.imageView?.contentMode = .scaleAspectFit
        spardaButton.imageView?.contentMode = .scaleAspectFit
        
        RunnerData().getTasks { (taskList) in
            self.taskList = taskList.data
            self.taskListStation = self.taskList.filter( {$0.start_station_name == self.station.rawValue} )
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapAthens(_ sender: UIButton) {
        station = .Athens
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
    }
    
    @IBAction func didTapPhokis(_ sender: UIButton) {
        station = .Phokis
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
    }
    
    @IBAction func didTapAkadia(_ sender: UIButton) {
        station = .Arkadia
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
    }
    
    @IBAction func didTapSparta(_ sender: UIButton) {
        station = .Sparta
        taskListStation = taskList.filter( {$0.start_station_name == station.rawValue} )
        tableView.reloadData()
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListStation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListTableViewCell.self), for: indexPath) as! TaskListTableViewCell
    
        let task = taskListStation[indexPath.row]
        
        cell.itemImageView.image = task.image
        
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
