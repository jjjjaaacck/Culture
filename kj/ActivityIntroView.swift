//
//  ActivityIntroView.swift
//  kj
//
//  Created by 劉 on 2016/5/29.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import SnapKit

class ActivityIntroView: UIView {

    var titleLabel = UILabel()
    var contentLabel = UILabel()
    var moreButton = UIButton()
    var width: CGFloat = 0
    var contentLabelHeight: CGFloat = 0
    var contentLabelHeightConstraint: Constraint!
    var isExpand = false
    
    fileprivate let ACTIVITY_INTRODUCTION = "活 動 簡 介"
    fileprivate let MORE = "...More"
    fileprivate let CLOSE = "Close..."
   
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(width: CGFloat, data: String) {
        self.init(frame: CGRect.zero)
        
        let content = data.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if content != "" {
            addSubview(titleLabel)
            addSubview(contentLabel)
            addSubview(moreButton)
            
            self.width = width
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(10)
                make.leading.trailing.equalTo(0)
                make.height.equalTo(20)
            }
            
            contentLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(15)
                make.trailing.equalTo(-15)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                contentLabelHeightConstraint = make.height.equalTo(100).constraint
            }
            
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.flatGray().cgColor
            self.layer.cornerRadius = 5
            
            titleLabel.text = ACTIVITY_INTRODUCTION
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textAlignment = .center
            
            contentLabel.numberOfLines = 0
            contentLabel.lineBreakMode = .byWordWrapping
            contentLabel.font = contentLabel.font?.withSize(15)
            
            setContent(content)
        }
        
    }
    
    func setContent(_ content: String) {
        contentLabel.text = content
        contentLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        
        let size = contentLabel.sizeThatFits(CGSize(width: self.width-30, height: CGFloat.greatestFiniteMagnitude))
        if size.height <= 100 {
            setToUnexpandableState(size.height)
        }
        else {
            setMoreButton()
        }
        contentLabelHeight = size.height
    }
    
    func setMoreButton() {
        moreButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
            make.width.equalTo(60)
        }
        
        moreButton.setTitle(MORE, for: UIControlState())
        moreButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        moreButton.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)), for: UIControlState())
        moreButton.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)), for: .highlighted)
        moreButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        moreButton.titleLabel?.textAlignment = .center
        moreButton.layer.cornerRadius = 3
        moreButton.clipsToBounds = true
        moreButton.addTarget(self, action: #selector(ActivityIntroView.moreButtonClick), for: .touchUpInside)
        
        self.snp.makeConstraints { (make) in
            make.bottom.equalTo(moreButton).offset(10)
        }
    }
    
    func setToUnexpandableState(_ height: CGFloat) {
        contentLabel.snp.updateConstraints({ (make) in
            make.height.equalTo(height)
        })
        
        self.snp.makeConstraints({ (make) in
            make.bottom.equalTo(contentLabel).offset(10)
        })
    }
    
    //MARK: Action
    
    func moreButtonClick() {
        isExpand = !isExpand
        if isExpand {
            contentLabelHeightConstraint.update(offset: contentLabelHeight)
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
            
            moreButton.setTitle(CLOSE, for: UIControlState())
        }
        else {
            
            contentLabelHeightConstraint.update(offset: 100)
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
            
            moreButton.setTitle(MORE, for: UIControlState())
        }
    }
}
