//
//  File.swift
//  kj
//
//  Created by 劉 on 2016/12/16.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    let activityIndicatorBackgroundView = UIView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let textLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.addSubview(activityIndicatorView)
        activityIndicatorBackgroundView.addSubview(textLabel)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textLabel.text = "下載資料中..."
        activityIndicatorBackgroundView.backgroundColor = UIColor.white
        activityIndicatorBackgroundView.alpha = 0.8
        activityIndicatorBackgroundView.layer.cornerRadius = 10
        activityIndicatorView.startAnimating()
        
        activityIndicatorBackgroundView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        activityIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(activityIndicatorView.snp.trailing).offset(10)
            make.top.equalTo(0)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
