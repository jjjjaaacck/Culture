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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addSubview(myTableView)
        myTableView.delegate = self
        
        loadBookmark()
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.view)
        }
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
    }
    
    //MARK: DataTableViewsDelegate
    
    func selectRow(_ mainDataId: String) {
        self.performSegue(withIdentifier: "showBookmarkDetail", sender: mainDataId)
    }
    
    func bookmarkClick(currentBookMarkState: Bool, completion: @escaping (Bool) -> Void) {
        if currentBookMarkState {
            let alertController = UIAlertController(title: "移除書籤", message: "確定要移除書籤嗎", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (result : UIAlertAction) -> Void in
                completion(false)
            }
            let okAction = UIAlertAction(title: "確定", style: .default) { (result : UIAlertAction) -> Void in
                completion(true)
                self.loadBookmark()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            completion(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller: TransitionViewController = segue.destination as! TransitionViewController
        controller.mainDataId = sender as! String
    }
    
}
