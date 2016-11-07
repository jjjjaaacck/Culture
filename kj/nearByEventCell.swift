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
    
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var locIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
