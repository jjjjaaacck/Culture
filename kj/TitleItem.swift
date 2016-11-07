//
//  TitleItem.swift
//  kj
//
//  Created by 劉 on 2016/1/22.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import SnapKit

class TitleItem: UIView {

    fileprivate let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image : UIImage, index: Int) {
        self.init(frame: CGRect.zero)
        
        self.imageView.image = image
        self.tag = index
    }
    
    override func layoutSubviews() {
        self.addSubview(imageView)
        
        self.isUserInteractionEnabled = true
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
}
