//
//  TaskListTableViewCell.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/3.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var itemStatus: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
