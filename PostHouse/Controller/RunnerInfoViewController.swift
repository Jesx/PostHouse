//
//  RunnerInfoViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/9.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RunnerInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalKiloMeters: UILabel!
    @IBOutlet weak var runnerLevelButton: UIButton!
    
    var runnerHistory = [RunnerHistoryResponse.RunnerHistoryData]()
    var runnerMedal: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runnerLevelButton.imageView?.contentMode = .scaleAspectFit
        runnerLevelButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        runnerLevelButton.layer.cornerRadius = 10
        runnerLevelButton.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1))
        SVProgressHUD.show()
        RunnerData().runnerHistory { (response) in
            print(response.message)
            
            guard let data = response.data else { return }
            self.runnerHistory = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        
        RunnerData().runnerMedal { (response) in
            self.runnerMedal = response.data.badge_name
            DispatchQueue.main.async {
                self.totalKiloMeters.text = "\(response.data.distance)"
                SVProgressHUD.dismiss()
            }
        }
    }
    @IBAction func didTapMedal(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: nil)
        let runnerLevelAlertVC = storyboard.instantiateViewController(identifier: "RunnerLevelAlertVC") as! RunnerLevelAlertViewController
        runnerLevelAlertVC.level = runnerMedal
        present(runnerLevelAlertVC, animated: true, completion: nil)
        
    }
    @IBAction func didTapClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension RunnerInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runnerHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RunnerInfoTableViewCell.self), for: indexPath) as! RunnerInfoTableViewCell
        
        let history = runnerHistory[indexPath.row]
        
        cell.itemLabel.text = "貨品：\(history.good_name)"
        cell.startStationLabel.text = history.start_station_name
        cell.destinationStationLabel.text = history.des_station_name
        cell.distanceLabel.text = "\(history.distance)公里"
        cell.weightLabel.text = "\(history.weight)kg"
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
}
