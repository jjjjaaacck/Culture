//
//  CalendarTableViewCell.swift
//  kj
//
//  Created by 劉 on 2015/10/17.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet var view0: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var category: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view0.layer.cornerRadius = view0.frame.width / 2
        view1.layer.cornerRadius = view1.frame.width / 2
        view2.layer.cornerRadius = view2.frame.width / 2
        view3.layer.cornerRadius = view3.frame.width / 2
        background.layer.cornerRadius = 10
        background.layer.opacity = 0.8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
