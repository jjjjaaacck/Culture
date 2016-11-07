//
//  otherTitle.swift
//  kj
//
//  Created by 劉 on 2015/10/18.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class otherTitle: UINavigationBar {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 20)!]
    }
}
