//
//  DataTableViews.swift
//  kj
//
//  Created by 劉 on 2016/1/26.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import BoltsSwift
import SnapKit
import RealmSwift
import Kingfisher

protocol DataTableViewsDelegate {
    func selectRow(_ mainDataId: String)
    func bookmarkClick(currentBookMarkState: Bool) -> Task<AnyObject>
}

class DataTableViews: UIView, UITableViewDataSource, UITableViewDelegate, DataTableViewCellDelegate {
    
    fileprivate var tableView = UITableView()
    fileprivate let progressIcon = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var currentOffset: CGFloat = 0.0
    
    var category: Int?
    var data = [MainData]()
    
    var delegate: DataTableViewsDelegate?
    
    convenience init(category: Int) {
        self.init(frame: CGRect.zero)
       
        print("\nRealm path : \n\(Realm.Configuration.defaultConfiguration.fileURL!)\n")
     
        self.category = category
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.isHidden = true
        tableView.alpha = 0
        tableView.tableFooterView = UIView()
        progressIcon.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.addSubview(tableView)
        self.addSubview(progressIcon)
        
        tableView.backgroundColor =  UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
        let nib: UINib = UINib(nibName: "DataTableViewCellWithImage", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "imageCell")
        let nib2: UINib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        progressIcon.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = category {
            print("\(category) -> numberOFRowsInSection : \(data.count)")
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleData = data[(indexPath as NSIndexPath).row]

        if singleData.imageUrl != "" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DataTableViewCellWithImage
            cell.activityImage.kf.setImage(with: URL(string: singleData.imageUrl))
            cell = setTableViewCell(cell, data: singleData) as! DataTableViewCellWithImage
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DataTableViewCell
            cell = setTableViewCell(cell, data: singleData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[(indexPath as NSIndexPath).row].imageUrl != "" ? 300.0 : 115.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectRow(data[(indexPath as NSIndexPath).row].id)
    }
    
    //MARK: DataTableViewCellDelegate
    
    func dataTableViewCellRemoveBookmark(currentBookMarkState: Bool) -> Task<AnyObject> {
        return (delegate?.bookmarkClick(currentBookMarkState: currentBookMarkState))!
    }
    
    //MARK: method
    
    func setTableViewCell(_ cell: DataTableViewCell, data: MainData) -> DataTableViewCell {
        cell.mainDataId = data.id
        cell.activityName.text = data.title
        if data.informations.count == 0 {
            cell.activityLocation.text = "沒有提供地點喔～"
        }
        else if data.informations[0].location == "" {
            cell.activityLocation.text = "沒有提供地點喔～"
        }
        else {
            cell.activityLocation.text = data.informations[0].location
        }
        
        cell.activityTime.text = (data.endDate != nil ) ? dateToString(date: data.startDate!) + " ~ " + dateToString(date: data.endDate!) : dateToString(date: data.startDate!)
        cell.setCategory(data.category)
        cell.setBookMarkImage(data.bookMark)
        cell.delegate = self
        
        return cell
    }
    
    func reloadTableView() {
        
        self.tableView.reloadData()
        self.progressIcon.stopAnimating()
        self.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.tableView.alpha = 1
        })
    }
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(DataTableViews.refreshTableViewData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshTableViewData(_ sender: UIRefreshControl) {
        FetchData.sharedInstance.RequestForData(self.category!).continueWith { (task: Task<AnyObject>) -> AnyObject? in
            self.data = task.result as! [MainData]
            
            RealmManager.sharedInstance.addDataTableViewData(self.data)
            
            self.tableView.reloadData()
            
            self.refreshControl.endRefreshing()
            
            return nil
        }
    }
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func isHiddenTable() -> Bool {
        return tableView.isHidden
    }
    
    func scrollToTop() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
}
