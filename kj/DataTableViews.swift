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
    func bookmarkClick(currentBookMarkState: Bool, completion: @escaping (_ isReset: Bool) -> Void)
}

class DataTableViews: UIView, UITableViewDataSource, UITableViewDelegate, DataTableViewCellDelegate {
    
    fileprivate var tableView = UITableView()
    fileprivate let progressIcon = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let progressView = UIProgressView(progressViewStyle: .default)
    fileprivate let errorLabel = UILabel()
    
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
        self.addSubview(progressView)
        self.addSubview(errorLabel)
        
        tableView.backgroundColor =  UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
        let nib: UINib = UINib(nibName: "DataTableViewCellWithImage", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "imageCell")
        let nib2: UINib = UINib(nibName: "DataTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "cell")
        
        progressIcon.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        errorLabel.text = "下拉重新整理"
        errorLabel.sizeToFit()
        errorLabel.isHidden = true
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(5)
        }
        
        progressIcon.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.bottom.equalTo(progressView.snp.top).offset(-50)
        }
        
        errorLabel.snp.makeConstraints { (make) in
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
    
    func dataTableViewCellResetBookmark(currentBookMarkState: Bool, completion: @escaping (Bool) -> Void) {
        delegate?.bookmarkClick(currentBookMarkState: currentBookMarkState, completion: { (isReset) -> Void in
            completion(isReset)
        })
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
    
    func stopLoading() {
        self.progressIcon.stopAnimating()
        self.progressView.isHidden = true
        self.tableView.isHidden = false
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.tableView.alpha = 1
        })
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
        self.stopLoading()
        errorLabel.isHidden = true
    }
    
    func showErrorLabel() {
        self.stopLoading()
        errorLabel.isHidden = false
    }
    
    func setProgress(progress: Double) {
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(progress), animated: true)
            print("category: \(self.category!), progress: \(progress)")
        }
    }
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(DataTableViews.refreshTableViewData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refreshTableViewData(_ sender: UIRefreshControl) {
        FetchData.sharedInstance.RequestForData(self.category!, sendCurrentProgress: { progress in}).continueWith { (task: Task<AnyObject>) -> AnyObject? in
            if task.faulted {
                print(task.error!)
                DispatchQueue.main.sync {
                    self.refreshControl.endRefreshing()
                }
                return nil
            }
            
            self.data = task.result as! [MainData]
            
            RealmManager.sharedInstance.addDataTableViewData(self.data).continueOnSuccessWith { task in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            
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
