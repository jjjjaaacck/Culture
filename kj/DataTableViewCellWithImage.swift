//
//  TblViewCellWithImage.swift
//  kj
//
//  Created by 劉 on 2015/8/14.
//  Copyright (c) 2015年 劉. All rights reserved.
//

import UIKit

class DataTableViewCellWithImage: DataTableViewCell {
    
    @IBOutlet var activityImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityImage.layer.cornerRadius = 10
        activityImage.layer.masksToBounds = true
        activityImage.contentMode = UIViewContentMode.scaleAspectFill
        
        createOverlay(CGRect(x: 0, y: activityImage.frame.maxY-101, width: 100, height: 100), view : activityImage)
    }
}
