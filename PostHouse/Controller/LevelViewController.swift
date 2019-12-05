//
//  LevelViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var cardView: CardView!
    
    var progress: Progress!
    
    var level = Level.One
    
    var station = Station.Athens

    var stationLevel = 0
    var totalWeight: Float = 0
    var income = 0
    
    enum Level: Int {
        case One, Two, Three, Four
        
        var spec: Int {
            switch self {
            case .One: return 10
            case .Two: return 20
            case .Three: return 100
            case .Four: return 1000
            }
        }
        var startValue: Int {
            switch self {
            case .One: return 0
            case .Two: return 10
            case .Three: return 20
            case .Four: return 100
            }
        }
        
        var imageName: String {
            switch self {
            case .One: return "Level1"
            case .Two: return "Level2"
            case .Three: return "Level3"
            case .Four: return "Level4"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        progressView.progressTintColor = station.foregroundColor
        
        initialLabel.text = "0"
        endLabel.text = "0"
        
        self.navigationController?.navigationBar.barTintColor = station.color
        self.view.backgroundColor = station.color
        self.cardView.backgroundColor = station.foregroundColor
        
        getLevel()
        
    }
    
    
    func getLevel() {
        activityIndicator.isHidden = false
        PostHouseData().getStationLevel { (getStationLevel) in
            
            self.stationLevel = getStationLevel.data[self.station.id - 1].level
            self.totalWeight = getStationLevel.data[self.station.id - 1].totalWeight
            self.income = getStationLevel.data[self.station.id - 1].income
            
            switch self.stationLevel {
            case 1:
                self.level = .One
            case 2:
                self.level = .Two
            case 3:
                self.level = .Three
            case 4:
                self.level = .Four
            default:
                break
            }
            
            DispatchQueue.main.async {
                self.progressSetting()
                self.initialLabel.text = String(self.level.startValue)
                self.endLabel.text = String(self.level.spec)
                self.imageView.image = UIImage(named: self.level.imageName)
                
                self.totalWeightLabel.text = String(self.totalWeight)
                self.levelLabel.text = String(self.stationLevel)
                self.incomeLabel.text = String(self.income)
    
                self.activityIndicator.isHidden = true
            }
            
        }
    }
    
    func progressSetting() {
        progress = Progress(totalUnitCount: Int64(level.spec))
        progress.completedUnitCount = Int64(totalWeight)
        progressView.setProgress(Float(progress.fractionCompleted), animated: true)
    }
    
    @IBAction func closeWindow(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}


