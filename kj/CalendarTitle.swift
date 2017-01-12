//
//  CalendarTitle.swift
//  kj
//
//  Created by 劉 on 2015/10/18.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class CalendarTitle: UINavigationBar {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.54, green:0.54, blue:0.54, alpha:1), NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 20)!]
    }
}
