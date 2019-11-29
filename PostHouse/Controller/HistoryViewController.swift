//
//  HistoryViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var freightHistory = [GetFreight.FreightData]()
    var station = Station.Athens
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        self.navigationController?.navigationBar.barTintColor = station.color

        loadData()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    func loadData() {
        self.activityIndicator.isHidden = false
        PostHouseData().getFreights { (getFreight) in
            let freightsByStation = getFreight.data.filter({ $0.start_station.name == self.station.rawValue })
            self.freightHistory = freightsByStation.filter({ $0.status == "已抵達" || $0.status == "已註銷" })

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func closeWindow(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return freightHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HistoryTableViewCell.self), for: indexPath) as! HistoryTableViewCell
        
        let freight = freightHistory[indexPath.row]
        
//        if let photoUrl = freight.photo_url {
//            downloadImage(urlString: photoUrl) { (data) in
//                cell.itemImageView.image = UIImage(data: data)
//            }
//        } else {
//            cell.itemImageView.image = UIImage(named: "dummy-image")
//        }
        
        if let image = freight.image {
            cell.itemImageView.image = image
        } else {
            cell.itemImageView.image = UIImage(named: "dummy-image")
        }
        
        cell.nameLabel.text = freight.name
        cell.weightLabel.text = String(freight.weight)
        cell.statusLabel.text = freight.status
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}
