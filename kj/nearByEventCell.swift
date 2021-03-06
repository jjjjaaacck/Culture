//
//  nearByEventCell.swift
//  googlemap4
//
//  Created by BurdieTai on 2015/10/22.
//  Copyright © 2015年 BurdieTai. All rights reserved.
//

import Foundation
import UIKit

class nearByEventCell : UITableViewCell{
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
