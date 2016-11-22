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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var allLocations : Dictionary<Int, [String]>?
    var locationTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        tableView.bounces = false
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.allLocations =  [
            0:[String](["台北", "新北", "基隆", "桃園", "新竹"]),
            1:[String](["苗栗", "台中", "彰化", "南投", "雲林"]),
            2:[String](["嘉義", "台南", "高雄", "屏東"]),
            3:[String](["宜蘭", "花蓮", "台東"]),
            4:[String](["澎湖", "金門", "連江", "綠島", "蘭嶼"]),
        ]
        
        self.locationTitle = ["北部", "中部", "南部", "東部", "外島"]
        
        tableView.dataSource = self
        tableView.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MapSearchTblViewCell
        let section = allLocations?[(indexPath as NSIndexPath).section]
        cell.label.text = section![(indexPath as NSIndexPath).row]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = allLocations?[section]
        return (section?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (allLocations?.count)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = allLocations?[indexPath.section]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "LocationSearchResultViewController") as! LocationSearchResultViewController
        controller.location = section![indexPath.row]
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        self.view.window?.layer.add(transition,forKey:nil)
        self.present(controller, animated: false, completion: nil)
        
    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let locationResultViewController = segue.destination as! LocationSearchResultViewController
//        locationResultViewController.location = sender as! String
//    }
//    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationTitle[section]
    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width/9.25, height: 30))
//        label.center.x = tableView.center.x
//        label.font = UIFont(name: "System", size: 15)
//        label.textColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1)
//        label.text = locationTitle[section]
//        view.addSubview(label)
//        view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
//        return view
//    }
    
    
    
    /*func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return locationTitle
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
