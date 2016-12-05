//
//  SearchLocationViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/21.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class SearchLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    
    var allLocations = [
        0:[String](["台北", "新北", "基隆", "桃園", "新竹"]),
        1:[String](["苗栗", "台中", "彰化", "南投", "雲林"]),
        2:[String](["嘉義", "台南", "高雄", "屏東"]),
        3:[String](["宜蘭", "花蓮", "台東"]),
        4:[String](["澎湖", "金門", "連江", "綠島", "蘭嶼"]),
        ]
    var locationTitle = ["北部", "中部", "南部", "東部", "外島"]
    var menuButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        
        menuButton.image = UIImage(named: "menu")
        menuButton.style = .plain
        menuButton.tintColor = UIColor.white
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 58/255, green: 122/255, blue: 216/255, alpha: 1)
        self.navigationItem.title = "地區活動"
        self.navigationItem.leftBarButtonItem = menuButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MapSearchTblViewCell
        let section = allLocations[(indexPath as NSIndexPath).section]
        cell.label.text = section![(indexPath as NSIndexPath).row]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = allLocations[section]
        return (section?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = allLocations[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LocationSearchResultViewController") as! LocationSearchResultViewController
        controller.location = section![indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationTitle[section]
    }

}
