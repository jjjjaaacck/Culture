//
//  subtitle.swift
//  kj
//
//  Created by 劉 on 2015/10/17.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class subtitle: UINavigationBar {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Apple SD Gothic Neo", size: 22)!]
    }
}
