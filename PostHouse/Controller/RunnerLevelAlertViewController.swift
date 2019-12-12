//
//  RunnerLevelAlertViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/9.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class RunnerLevelAlertViewController: UIViewController {

    @IBOutlet weak var keepGoingButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    
    var level: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keepGoingButton.layer.cornerRadius = 10
        keepGoingButton.clipsToBounds = true
        
        levelLabel.text = level
    }
    @IBAction func didTapKeepGoing(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
