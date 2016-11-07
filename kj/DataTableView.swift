//
//  DataTableView.swift
//  kj
//
//  Created by 劉 on 2015/10/10.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class DataTableView: UITableView {
    var coreDataController = CoreDataController()
    var _tableViewModel = TableViewModel()
    var isUpadted = false
    
     init(frame: CGRect, style: UITableViewStyle,tableViewModel: TableViewModel) {
        super.init(frame: frame, style: style)
        self._tableViewModel = tableViewModel
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataTableView.updateTableView(_:)), name: NSNotification.Name(rawValue: "reloadMainViewFromBookmark"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DataTableView.toTopTableView(_:)), name: NSNotification.Name(rawValue: "tableViewToTop"), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh(_ sender: AnyObject){
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
//            var count = self.coreDataController.getModelByCategory(sender.tag, sort: "title").count
//            print("pre \(count)")
//            self.coreDataController.updateDataByCategory(sender.tag)
//            self._tableViewModel.AddDataByCategory(sender.tag)
//            self.isUpadted = true
//            NotificationCenter.default.post( name: Notification.Name(rawValue: "UpdateNotification"), object: self, userInfo: ["update": self._tableViewModel])
////            self.reloadData()
//            count = self.coreDataController.getModelByCategory(sender.tag, sort: "title").count
//            print("aft \(count)")
//            sender.endRefreshing()
//        }
    }
    
    func setUpdateState(_ bool : Bool){
        self.isUpadted = bool
    }
    
    func getModel()->TableViewModel{
        return self._tableViewModel
    }
    
    func updateTableView(_ nsn: Notification) {
        self.reloadData()
    }
    
    func toTopTableView(_ nsn: Notification) {
        let userInfo = (nsn as NSNotification).userInfo as! [ String : Int]
        //self.tableViewModel = userInfo["update"] as! TableViewModel
        
        if userInfo["nowPage"] == self.tag {
            UIView.animate(withDuration: 0.2, animations: {
                //self.contentScrollView.contentOffset = CGPointMake(0, 0)
                self.contentOffset = CGPoint(x: 0, y: 0)
            })
        }
    }
    
    deinit {
        NotificationCenter.default .removeObserver ( self )
    }

}
