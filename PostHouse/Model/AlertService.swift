//
//  AlertService.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/4.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(image: UIImage?, text: String, completion: (() -> Void)?) -> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        alertVC.uiImage = image
        alertVC.buttonAction = completion
        
        return alertVC
    }
}
