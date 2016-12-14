//
//  MainIntroView.swift
//  kj
//
//  Created by 劉 on 2016/5/7.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

enum ButtonType: Int {
    case session = 0
    case web = 1
    case sales = 2
}

protocol MainIntroViewDelegate {
    func mainIntroViewSessionButtonClick()
    func mainIntroViewWebButtonClick()
    func mainIntroViewSalesButtonClick()
    func mainIntroViewShareButtonClick()
}

class MainIntroView: UIView {
    var mainImageView = UIImageView()
    var titleIcon = UIImageView()
    var titleLabel = UILabel()
    var locationIcon = UIImageView()
    var locationLabel = UILabel()
    var dateIcon = UIImageView()
    var dateLabel = UILabel()
    var ticketIcon = UIImageView()
    var ticketLabel = UILabel()
    var sessionButton = UIButton()
    var webButton = UIButton()
    var salesButton = UIButton()
    var shareButton = UIButton()
    
    var width: CGFloat = 0
    var data: MainData!
    var delegate: MainIntroViewDelegate?
    
    fileprivate let ACTIVITY_SESSION = "活動場次"
    fileprivate let WEB = "活動網站"
    fileprivate let SALES_WEB = "售票網站"
    fileprivate let NO_LOCATION = "沒有提供地點喔～"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(width: CGFloat, data: MainData) {
        
        self.init(frame: CGRect.zero)
        
        addSubview(mainImageView)
        addSubview(titleIcon)
        addSubview(titleLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
        addSubview(ticketIcon)
        addSubview(ticketLabel)
        addSubview(sessionButton)
        addSubview(webButton)
        addSubview(salesButton)
        addSubview(shareButton)
        
        self.width = width
        self.data = data
        
        mainImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(self)
            make.height.equalTo(0)
        }
        
        titleIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.top.equalTo(mainImageView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleIcon.snp.trailing).offset(10)
            make.trailing.equalTo(0)
            make.top.equalTo(titleIcon)
        }
        
        locationIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleIcon)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self)
            make.top.equalTo(locationIcon)
           // make.height.equalTo(0)
        }
        
        dateIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleIcon)
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self)
            make.top.equalTo(dateIcon)
           // make.height.equalTo(0)
        }
        
        ticketIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleIcon)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }
        
        ticketLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(shareButton.snp.leading)
            make.top.equalTo(ticketIcon)
          //  make.height.equalTo(0)
        }
        
//        sessionButton.snp.makeConstraints { (make) in
//            make.leading.equalTo(self)
//            make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//            make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//            make.bottom.equalTo(self)
//        }
        
        if !data.webUrl.isEmpty && !data.salesUrl.isEmpty {
            setButtonConstraint(button: sessionButton)
            setButtonConstraint(button: webButton)
            setButtonConstraint(button: salesButton)
            sessionButton.snp.makeConstraints({ (make) in
                make.leading.equalTo(self)
            })
            webButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
            })
            setButton(webButton, type: .web)
            
            salesButton.snp.makeConstraints({ (make) in
                make.trailing.equalTo(self)
            })
            setButton(salesButton, type: .sales)
        }
        else if !data.webUrl.isEmpty && data.salesUrl.isEmpty {
            setButtonConstraint(button: sessionButton)
            setButtonConstraint(button: webButton)
            sessionButton.snp.makeConstraints({ (make) in
                make.leading.equalTo(self.width/7)
            })
            webButton.snp.makeConstraints({ (make) in
                make.trailing.equalTo(-self.width/7)
            })
            
            setButton(webButton, type: .web)
        }
        else if data.webUrl.isEmpty && !data.salesUrl.isEmpty {
            setButtonConstraint(button: sessionButton)
            setButtonConstraint(button: salesButton)
            sessionButton.snp.makeConstraints({ (make) in
                make.leading.equalTo(self.width/7)
            })
            salesButton.snp.makeConstraints({ (make) in
                make.trailing.equalTo(-self.width/7)
            })
            setButton(salesButton, type: .sales)
        }
        else {
            setButtonConstraint(button: sessionButton)
            sessionButton.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
            })
        }
        
//        if !data.webUrl.isEmpty {
////            webButton.snp.makeConstraints({ (make) in
////                make.centerX.equalTo(self)
////                make.top.equalTo(ticketLabel.snp.bottom).offset(20)
////                make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
////                make.bottom.equalTo(self)
////            })
////            setButton(webButton, type: .web)
//            
//            if !data.salesUrl.isEmpty {
//                sessionButton.snp.makeConstraints { (make) in
//                    make.leading.equalTo(self)
//                    make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//                    make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//                    make.bottom.equalTo(self)
//                }
//                
//                webButton.snp.makeConstraints({ (make) in
//                    make.centerX.equalTo(self)
//                    make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//                    make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//                    make.bottom.equalTo(self)
//                })
//                setButton(webButton, type: .web)
//                
//                salesButton.snp.makeConstraints({ (make) in
//                    make.trailing.equalTo(self)
//                    make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//                    make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//                    make.bottom.equalTo(self)
//                })
//                setButton(salesButton, type: .sales)
//            }
//            else {
//                sessionButton.snp.makeConstraints { (make) in
//                    make.leading.equalTo(self)
//                    make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//                    make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//                    make.bottom.equalTo(self)
//                }
//            }
//        }
//        
//        else {
//            if !data.salesUrl.isEmpty {
//                salesButton.snp.makeConstraints({ (make) in
//                    make.centerX.equalTo(self)
//                    make.top.equalTo(ticketLabel.snp.bottom).offset(20)
//                    make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
//                    make.bottom.equalTo(self)
//                })
//                setButton(salesButton, type: .sales)
//            }
//        }
        
        shareButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self)
            make.bottom.equalTo(sessionButton.snp.top).offset(-20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        mainImageView.layer.cornerRadius = 5
        mainImageView.clipsToBounds = true
        
        titleIcon.image = UIImage(named: "event")
        locationIcon.image = UIImage(named: "location")
        dateIcon.image = UIImage(named: "calendar")
        ticketIcon.image = UIImage(named: "ticket")
        
        shareButton.setBackgroundImage(UIImage(named: "share1"), for: UIControlState())
        shareButton.layer.opacity = 0.75
        shareButton.addTarget(self, action: #selector(MainIntroView.shareButtonClick), for: UIControlEvents.touchUpInside)
        
        setButton(sessionButton, type: .session)
        setContent()
    }

    //MARK: Action
    
    func sessionButtonClick() {
        delegate?.mainIntroViewSessionButtonClick()
    }
    
    func webButtonClick() {
        delegate?.mainIntroViewWebButtonClick()
    }
    
    func salesWebButtonClick() {
        delegate?.mainIntroViewSalesButtonClick()
    }
    
    func shareButtonClick() {
        delegate?.mainIntroViewShareButtonClick()
    }
    
    //MARK: Method
    
    func setContent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        if data.imageUrl != "" {
            KingfisherManager.shared.retrieveImage(with: URL(string: data.imageUrl)!, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheTye, imageUrl) in
                self.mainImageView.image = image
                let ratio = (image?.size.height)! / (image?.size.width)!
                let newHeight = self.width * ratio
                self.mainImageView.snp.updateConstraints({ (make) in
                    make.height.equalTo(newHeight)
                })
            })
        }
        
        if data.title != "" {
            setLabel(titleLabel, font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.black, text: data.title)
        }
        
        if data.startDate != nil {
            if data.endDate != nil {
                setLabel(dateLabel,
                         font: UIFont(name: "HelveticaNeue-Thin", size: 15)!,
                         color: UIColor.flatRed(),
                         text: dateFormatter.string(from: data.startDate!) + " ~ " + dateFormatter.string(from: data.endDate!)
                )
                
            }
            else {
                setLabel(dateLabel,
                         font: UIFont(name: "HelveticaNeue-Thin", size: 15)!,
                         color: UIColor.flatRed(),
                         text: dateFormatter.string(from: data.startDate!)
                )
            }
        }
        
        if data.informations.count == 0 {
             setLabel(locationLabel, font: UIFont.systemFont(ofSize: 16), color: UIColor.flatBlue(), text: NO_LOCATION)
            ticketIcon.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize(width: 0, height: 0))
            })
        }
        else {
            if data.informations[0].location != "" {
                setLabel(locationLabel, font: UIFont.systemFont(ofSize: 16), color: UIColor.flatBlue(), text: data.informations[0].location)
            }
            else {
                setLabel(locationLabel, font: UIFont.systemFont(ofSize: 16), color: UIColor.flatBlue(), text: NO_LOCATION)
            }
            
            if data.informations[0].price != "" {
                setLabel(ticketLabel, font: UIFont(name: "HelveticaNeue-Thin", size: 14)!, color: UIColor.flatGreenColorDark(), text: data.informations[0].price)
            }
            else {
                ticketIcon.snp.updateConstraints({ (make) in
                    make.size.equalTo(CGSize(width: 0, height: 0))
                })
            }
        }
    }
    
    func setButton(_ button: UIButton, type: ButtonType) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.flatTeal().cgColor
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 12)!
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)), for: .highlighted)
        
        switch type {
            
        case .session:
            button.setImage(UIImage(named: "session"), for: .normal)
            button.setTitle(ACTIVITY_SESSION, for: .normal)
            button.addTarget(self, action: #selector(MainIntroView.sessionButtonClick), for: .touchUpInside)
        case .web:
            button.setImage(UIImage(named: "web"), for: .normal)
            button.setTitle(WEB, for: .normal)
            button.addTarget(self, action: #selector(MainIntroView.webButtonClick), for: .touchUpInside)
        case .sales:
            button.setImage(UIImage(named: "sales"), for: .normal)
            button.setTitle(SALES_WEB, for: .normal)
            button.addTarget(self, action: #selector(MainIntroView.salesWebButtonClick), for: .touchUpInside)
        }
        
        let buttonSize = CGSize(width: self.width / 3.5, height: self.width / 3.5)
        
        button.imageEdgeInsets =
            UIEdgeInsetsMake(10,
                             (buttonSize.width-buttonSize.height+buttonSize.height/3 + 10) / 2,
                             buttonSize.height/3,
                             (buttonSize.width-buttonSize.height+buttonSize.height/3 + 10) / 2)
        button.setTitleColor(UIColor.flatTeal(), for: UIControlState())
        button.titleLabel?.sizeToFit()
//        button.titleEdgeInsets =
//            UIEdgeInsetsMake(0,
//                             0,
//                             0,
//                             0)
        button.titleEdgeInsets =
            UIEdgeInsetsMake((button.imageView?.bounds.size.width)! + 10,
                             -(buttonSize.width + (button.titleLabel?.bounds.size.width)!/2),
                             0,
                             0)
    }
    
    func setButtonConstraint(button: UIButton) {
        button.snp.makeConstraints { (make) in
//            make.leading.equalTo(self)
            make.top.equalTo(ticketLabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: self.width / 3.5, height: self.width / 3.5))
            make.bottom.equalTo(self)
        }
    }
    
    func setLabel(_ label: UILabel, font: UIFont, color: UIColor, text: String) {
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.textColor = color
        label.text = text
        let newSize = label.sizeThatFits(CGSize(width: self.width - 40, height: CGFloat.greatestFiniteMagnitude))
        label.snp.makeConstraints { (make) in
            make.height.equalTo(newSize.height)
        }
    }
}
