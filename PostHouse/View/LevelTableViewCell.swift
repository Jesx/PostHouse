//
//  LevelTableViewCell.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/26.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {

    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
