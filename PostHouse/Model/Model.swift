
//
//  Model.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/12/10.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

enum Station: String {
    case Athens = "雅典"
    case Phokis = "菲基斯"
    case Arkadia = "阿卡迪亞"
    case Sparta = "斯巴達"

    var id: Int {
        switch self {
        case .Athens: return 1
        case .Phokis: return 2
        case .Arkadia: return 3
        case .Sparta: return 4
        }
    }
    
    var color: UIColor {
        switch self {
        case .Athens: return #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5764705882, alpha: 1)
        case .Phokis: return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case .Arkadia: return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .Sparta: return #colorLiteral(red: 0.5803921569, green: 0.06666666667, blue: 0, alpha: 1)
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .Athens: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .Phokis: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case .Arkadia: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .Sparta: return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }
}
