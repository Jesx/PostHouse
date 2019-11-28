//
//  FreightViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class FreightViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var freightsByStation = [GetFreight.Data]()
    
    var station = Station.Athens

    var searchArray = [GetFreight.Data]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.tableFooterView = UIView()
        
        self.tabBarController?.tabBar.barTintColor = station.color
        self.navigationController?.navigationBar.barTintColor = station.color
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadData()
    }
    
    func loadData() {
        activityIndicator.isHidden = false
        PostHouseData().getFreights { (getFreight) in
            self.freightsByStation = getFreight.data.filter({ $0.start_station.name == self.station.rawValue }).filter( {$0.status != "已抵達"} )
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let secondTabNC = self.tabBarController?.viewControllers?[1] as! UINavigationController
                let historyVC  = secondTabNC.viewControllers.first as! HistoryViewController
                historyVC.station = self.station
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func didTapRefresh(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    @IBAction func closeWindow(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FreightDetailSegue", let indexPath = tableView.indexPathForSelectedRow {
            let freightDetailVC = segue.destination as! FreightDetailViewController
            freightDetailVC.freight = freightsByStation[indexPath.row]
        } else if segue.identifier == "AddFreightSegue" {
            let addFreightVC = segue.destination as! AddFreightViewController
            addFreightVC.station = station
        }
    }
    
}

extension FreightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return !searching ? freightsByStation.count : searchArray.count
    }
    
    func downloadImage(urlString: String, completion: @escaping (Data) -> ()) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    if let posterData = data {
                        
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                            completion(posterData)
                            
                        })
                    }
                    
                }
            }
            task.resume()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FreightTableViewCell.self), for: indexPath) as! FreightTableViewCell
        
        var freight = freightsByStation[indexPath.row]
        
        if searching {
            freight = searchArray[indexPath.row]
        }

        if let photoUrl = freight.photo_url {
            downloadImage(urlString: photoUrl) { (data) in
                cell.itemImageView.image = UIImage(data: data)
            }
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

extension FreightViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray = freightsByStation.filter({ $0.name.prefix(searchText.count) == searchText })
        
        searching = true
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
