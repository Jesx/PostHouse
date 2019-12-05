//
//  SelectedStationViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class SelectedStationViewController: UIViewController {
    
    var station = Station.Athens

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapAthens(_ sender: UIButton) {
        station = .Athens
        gotoNextView(station: station)
    }
    
    @IBAction func didTapPhokis(_ sender: UIButton) {
        station = .Phokis
        gotoNextView(station: station)
    }
    
    @IBAction func didTapArkadia(_ sender: UIButton) {
        station = .Arkadia
        gotoNextView(station: station)
    }
    
    @IBAction func didTapSparta(_ sender: UIButton) {
        station = .Sparta
        gotoNextView(station: station)
    }
    
    func gotoNextView(station: Station) {
        let freightTBC = storyboard?.instantiateViewController(identifier: "FreightTBC") as! UITabBarController
        let freightNC = freightTBC.viewControllers?.first as! UINavigationController
        let freightVC = freightNC.viewControllers.first as! FreightViewController
        
        freightVC.station = station
        
        let levelNC = freightTBC.viewControllers?[2] as! UINavigationController
        let levelVC = levelNC.viewControllers.first as! LevelViewController
        
        levelVC.station = station
        
        present(freightTBC, animated: true, completion: nil)
        
    }
    @IBAction func logout(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
