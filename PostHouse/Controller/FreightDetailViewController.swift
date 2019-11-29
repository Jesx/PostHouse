//
//  FreightDetailViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class FreightDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var destinaionLabel: UILabel!
    
    var freight: GetFreight.FreightData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
                
                            completion(posterData)
                            
                        })
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemNameLabel.text = freight.name
        weightLabel.text = "\(freight.weight)"
        descriptionLabel.text = freight.description
        statusLabel.text = freight.status
        currentLocationLabel.text = freight.now_station.name
        destinaionLabel.text = freight.des_station.name
        
        if let url = freight.photo_url {
            downloadImage(urlString: url) { (data) in
                self.imageView.image = UIImage(data: data)
            }
        }
        
    }
    
}
