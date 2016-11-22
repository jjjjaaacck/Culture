//
//  BookmarkViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/18.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit
import Kingfisher
import BoltsSwift

extension DataTableViews {
    func insertData(data: [MainData]) {
        self.data = data
        reloadTableView()
    }
}

class BookmarkViewController: UIViewController, DataTableViewsDelegate{

    @IBOutlet weak var navigationBar: CalendarTitle!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var data = [MainData]()
    var myTableView = DataTableViews()
    
    //    var tableViewModel = TableViewModel()
    //    var tableViewModelForMonth = TableViewModel()
    //    var tempTableViewModel = TableViewModel()
    //    var coreDataController = CoreDataController()
    //    var bookmarkModel = [Bookmark]()
    //    var idString = [String]()
    //    var idStringForMonth = [String]()
    //    var categoryArray = [Int]()
    //    var categoryArrayForMonth = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addSubview(myTableView)
        myTableView.delegate = self
        
        loadBookmark()
        //        myTableView.insertData(data: data)
        //        tempTableViewModel = tableViewModel
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.view)
        }
        //
        //        tableView.backgroundColor =  UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
        //        let nib: UINib = UINib(nibName: "TblViewCellWithImage", bundle: nil)
        //        tableView.register(nib, forCellReuseIdentifier: "imageCell")
        //        let nib2: UINib = UINib(nibName: "TblViewCell", bundle: nil)
        //        tableView.register(nib2, forCellReuseIdentifier: "cell")
        //
        //        tableView.tag = 0
        //        tableView.dataSource = self
        //        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadBookmark() {
        let filter = NSPredicate(format: "bookMark == true")
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith{ task in
            if let error = task.error {
                print("error: \(error)")
                self.myTableView.isHidden = true
            }
            else {
                self.myTableView.isHidden = false
                self.data = task.result as! [MainData]
                self.myTableView.insertData(data: self.data)
            }
        }
        //
        //        idString.removeAll()
        //        idStringForMonth.removeAll()
        //        bookmarkModel = coreDataController.getAllBookmark()
        //        for item in bookmarkModel {
        //            let data = coreDataController.getModelById(item.modelId!)
        //            let dataForMonth = coreDataController.getModelById_Month(item.modelId!)
        //            idString.append(item.modelId!)
        //            categoryArray.append(Int(data[0].category!))
        //            if !dataForMonth.isEmpty {
        //                idStringForMonth.append(dataForMonth[0].id!)
        //                categoryArray.append(Int(data[0].category!))
        //            }
        //        }
        //        tableViewModel.LoadById(idString)
        //        tableViewModelForMonth.LoadById(idStringForMonth)
    }
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return data.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    ////        if tempTableViewModel.dataHasImage(tableView.tag, indexPath : (indexPath as NSIndexPath).row){
    //        if data[indexPath.row].imageUrl != "" {
    //            var cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! TblViewCellWithImage
    ////            cell.activityBookmark.id = idString[indexPath.row]
    //            let url = URL(string: data[indexPath.row].imageUrl)
    //            cell.activityImage.contentMode = UIViewContentMode.scaleAspectFill
    ////            cell.activityImage.hnk_setImageFromURL(url!)
    //            cell.activityImage.kf.setImage(with: url)
    ////            cell.activityImage.kf_setImageWithURL(url!)
    //            cell = tempTableViewModel.setActivityData(cell, tableIndex : tableView.tag, index: (indexPath as NSIndexPath).row) as! TblViewCellWithImage
    //            cell.activityBookmark.addTarget(self, action: #selector(BookmarkViewController.bookmarkClick(_:)), for: UIControlEvents.touchUpInside)
    //            return cell
    //        }
    //        else{
    //            var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TblViewCell
    ////            cell.activityBookmark.id = idString[indexPath.row]
    //            cell = tempTableViewModel.setActivityData(cell, tableIndex : tableView.tag, index : (indexPath as NSIndexPath).row)
    //            cell.activityBookmark.addTarget(self, action: #selector(BookmarkViewController.bookmarkClick(_:)), for: UIControlEvents.touchUpInside)
    //            return cell
    //        }
    //    }
    //
    //    func bookmarkClick(_ sender: BookmarkButton) {
    //        let alert = UIAlertController(title: "", message:
    //            "刪除此活動的書籤", preferredStyle: UIAlertControllerStyle.actionSheet)
    //        self.present(alert, animated: true, completion: nil)
    //
    //        let pressOK = UIAlertAction(title:"確定", style: UIAlertActionStyle.default){
    //            UIAlertAction in
    //            self.coreDataController.changeBookMark(sender.id!)
    //            self.loadBookmark()
    //            self.tableView.reloadData()
    //
    //            //推送通知
    //            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadMainViewFromBookmark"), object: self)
    //        }
    //
    //        let pressCancel = UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel){
    //            UIAlertAction in
    //        }
    //        alert.addAction(pressOK)
    //        alert.addAction(pressCancel)
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return tempTableViewModel.dataHasImage(tableView.tag, indexPath : (indexPath as NSIndexPath).row) ? 300.0 : 115.0
    //    }
    //
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cellIndex = [categoryArray[(indexPath as NSIndexPath).row], idString[(indexPath as NSIndexPath).row]] as [Any]
    //        self.performSegue(withIdentifier: "showBookmarkDetail", sender: cellIndex)
    //    }
    
    //MARK: DataTableViewsDelegate
    
    func selectRow(_ mainDataId: String) {
        self.performSegue(withIdentifier: "showBookmarkDetail", sender: mainDataId)
    }
    
    func bookmarkClick(currentBookMarkState: Bool) -> Task<AnyObject> {
        let task = TaskCompletionSource<AnyObject>()
        if currentBookMarkState {
            let alertController = UIAlertController(title: "移除書籤", message: "確定要移除書籤嗎", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (result : UIAlertAction) -> Void in
                task.cancel()
            }
            let okAction = UIAlertAction(title: "確定", style: .default) { (result : UIAlertAction) -> Void in
                task.set(result: true as AnyObject)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return task.task
        }
        else {
            task.set(result: true as AnyObject)
            return task.task
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller: TransitionViewController = segue.destination as! TransitionViewController
        controller.mainDataId = sender as! String
    }
    
}
