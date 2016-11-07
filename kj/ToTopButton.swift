//
//  ToTopButton.swift
//  kj
//
//  Created by 劉 on 2016/5/4.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import SnapKit

protocol ToTopButtonDelegate {
    func toTopButtonClick()
}

class ToTopButton: UIView {
    fileprivate let buttonView = UIView()
    fileprivate let button = UIButton()
    
    var delegate: ToTopButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.addSubview(buttonView)
        self.addSubview(button)
        
        buttonView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.center.equalTo(self)
        }
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.margins.equalTo(10)
        }
        
        buttonView.layer.cornerRadius = 25
        buttonView.backgroundColor = UIColor.gray
        button.setImage(UIImage(named: "top2"), for: UIControlState())
        button.addTarget(self, action: #selector(ToTopButton.buttonClick), for: .touchUpInside)
    }
    
    func buttonClick() {
        delegate?.toTopButtonClick()
    }
}
