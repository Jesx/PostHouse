//
//  AlertService.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/4.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(image: UIImage?, itemName: String, itemLocation: String, destination: String, weight: Float, completion: (() -> Void)?) -> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        
        if let image = image {
            alertVC.uiImage = image
        } else {
            alertVC.uiImage = UIImage(named: "dummy-image")
        }
    
        alertVC.itemName = itemName
        alertVC.itemLocation = itemLocation
        alertVC.destination = destination
        alertVC.weight = weight
        
        alertVC.buttonAction = completion
        
        return alertVC
    }
}
