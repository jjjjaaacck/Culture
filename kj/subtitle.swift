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
        let shadow: NSShadow = NSShadow()
        shadow.shadowColor = UIColor(red:0, green:0.55, blue:0.3, alpha:1)
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        self.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Apple SD Gothic Neo", size: 22)!, NSShadowAttributeName: shadow]
    }
}
