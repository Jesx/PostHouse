//
//  AlertViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/4.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
     @IBOutlet weak var alertImageView: UIImageView!
     
     @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
     
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemLocationLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var buttonAction: (() -> Void)?
     
    var uiImage: UIImage!
    var itemName: String!
    var itemLocation: String!
    var destination: String!
    var weight: String!
    
    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertImageView.image = uiImage
        
        itemNameLabel.text = "是否要運送\(itemName ?? "")"
        itemLocationLabel.text = "貨品所在：\(itemLocation ?? "")"
        destinationLabel.text = "即將送往：\(destination ?? "")"
        weightLabel.text = "貨品總重：\(weight ?? "")"
        
        alertView.layer.borderColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        alertView.layer.borderWidth = 1
    }
    
    @IBAction func didTapBuy(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        buttonAction?()
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
