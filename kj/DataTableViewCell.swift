//
//  TblViewCell.swift
//  kj
//
//  Created by 劉 on 2015/8/14.
//  Copyright (c) 2015年 劉. All rights reserved.
//

import UIKit
import BoltsSwift

protocol DataTableViewCellDelegate {
    func dataTableViewCellRemoveBookmark(currentBookMarkState: Bool) -> Task<AnyObject>
}

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet var activityName: UILabel!
    @IBOutlet var activityLocation: UILabel!
    @IBOutlet var activityTime: UILabel!
    @IBOutlet var activityView: UIView!
    @IBOutlet var activityCategory: UIImageView!
    @IBOutlet var activityCategoryView: UIView!
    @IBOutlet weak var activityBookmark: UIButton!
    
    var mainDataId = ""
    var delegate: DataTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityView.layer.cornerRadius = 10
        activityCategoryView.layer.cornerRadius = activityCategoryView.frame.size.width/2
        activityCategoryView.backgroundColor = activityCategory.backgroundColor
        activityBookmark.addTarget(self, action: #selector(DataTableViewCell.bookmarkClick), for: .touchUpInside)
        createOverlay(CGRect(x: 0, y: 0, width: 100, height: 100), view : activityView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createOverlay(_ frame : CGRect, view : UIView)
    {
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        view.addSubview(overlayView)
        
        let maskLayer = CAShapeLayer()
        
        let path = CGMutablePath()
        
        let radius : CGFloat = activityCategoryView.frame.size.width/2
        
        path.addArc(center: CGPoint(x: radius-activityView.frame.minX+activityCategoryView.frame.minX, y: radius-activityView.frame.minY+activityCategoryView.frame.minY+overlayView.frame.minY), radius: radius+7, startAngle: 0.0, endAngle: 2*3.14, clockwise: false)
        
        //        CGPathAddArc(path, UnsafePointer<>, radius-activityView.frame.minX+activityCategoryView.frame.minX, radius-activityView.frame.minY+activityCategoryView.frame.minY+overlayView.frame.minY, radius+7, 0.0, 2 * 3.14, false)
        
        maskLayer.path = path;
        
        overlayView.layer.mask = maskLayer
    }
    
    func setCategory(_ categoryNumber: Int) {
        let image: UIImage
        
        switch categoryNumber {
        case 1:
            image = UIImage(named: "music")!
            activityCategory.backgroundColor = UIColor.flatRed()
        case 2:
            image = UIImage(named: "drama")!
            activityCategory.backgroundColor = UIColor.flatLime()
        case 3:
            image = UIImage(named: "dance")!
            activityCategory.backgroundColor = UIColor.flatYellow()
        case 4:
            image = UIImage(named: "family")!
            activityCategory.backgroundColor = UIColor.flatMaroon()
        case 5:
            image = UIImage(named: "indieMusic")!
            activityCategory.backgroundColor = UIColor.flatOrange()
        case 6:
            image = UIImage(named: "exibition")!
            activityCategory.backgroundColor = UIColor.flatMagenta()
        case 7:
            image = UIImage(named: "lecture")!
            activityCategory.backgroundColor = UIColor.flatMint()
        case 8:
            image = UIImage(named: "movie")!
            activityCategory.backgroundColor = UIColor.flatGreen()
        case 11:
            image = UIImage(named: "entertainment")!
            activityCategory.backgroundColor = UIColor.flatForestGreen()
        case 13:
            image = UIImage(named: "competition")!
            activityCategory.backgroundColor = UIColor.flatBrown()
        case 14:
            image = UIImage(named: "competition")!
            activityCategory.backgroundColor = UIColor.flatWatermelon()
        case 15:
            image = UIImage(named: "other")!
            activityCategory.backgroundColor = UIColor.flatPowderBlue()
        case 16:
            image = UIImage(named: "music")!
            activityCategory.backgroundColor = UIColor(red:0, green:0.75, blue:0.94, alpha:1)
        case 17:
            image = UIImage(named: "concert")!
            activityCategory.backgroundColor = UIColor.flatPink()
        case 19:
            image = UIImage(named: "class")!
            activityCategory.backgroundColor = UIColor.flatTeal()
        default:
            image = UIImage(named: "unknown")!
            activityCategory.backgroundColor = UIColor.flatNavyBlue()
        }
        
        activityCategory.image = image
        
        activityCategoryView.layer.cornerRadius = activityCategoryView.frame.size.width/2
        activityCategoryView.backgroundColor = activityCategory.backgroundColor
    }
    
    func setBookMarkImage(_ state: Bool) {
        let image = state ? UIImage(named: "onBookmark") : UIImage(named: "offBookmark")
//        let filter = NSPredicate(format: "id = %@", mainDataId)
        activityBookmark.setImage(image, for: .normal)
    }
    
    func onRecieveBookmarkResult(notification: Notification) {
        let filter = NSPredicate(format: "id = %@", mainDataId)
        let result = notification.userInfo?["result"] as! Bool
        
        setBookMarkImage(result)
        RealmManager.sharedInstance.updateBookmark(filter, state: result).continueOnSuccessWith { (task) ->
            AnyObject? in
            return nil
        }
    }
    
    func bookmarkClick() {
        let filter = NSPredicate(format: "id = %@", mainDataId)
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueOnSuccessWith{ (task) -> AnyObject? in
            let data = task as! [MainData]
            let bookmark = ["bookmark" : data[0].bookMark, "id" : self.mainDataId] as [String : Any]
            
            NotificationCenter.default.addObserver(self, selector: #selector(DataTableViewCell.onRecieveBookmarkResult(notification:)), name: NSNotification.Name(rawValue : "setBookmarkOnOrNot\(self.mainDataId)"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookmarkClick"), object: self, userInfo: bookmark)
            
            
            return nil
//            return self.delegate?.dataTableViewCellRemoveBookmark(currentBookMarkState: data[0].bookMark)
//        }.continueOnSuccessWith{ task  in
//            RealmManager.sharedInstance.updateBookmark(filter).continueWith { task in
//                self.setBookMarkImage(task.result as! Bool)
//            }
//        }
        }
    }
    
    
}
