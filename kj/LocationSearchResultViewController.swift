//
//  LocationSearchResultViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/22.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class LocationSearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var titleBar: UINavigationBar!
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    @IBOutlet var tableView: UITableView!
    let coreDataController = CoreDataController()
    var idCompare: String = ""
    var location = ""
    var model = [Model]()
    var infos = [Info]()
    var finalInfos = [Info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
            DispatchQueue.main.async(execute: {
                self.load()
                self.titleBar.topItem?.title = self.location
                self.tableView.backgroundColor =  UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
                let nib: UINib = UINib(nibName: "LocationSearchCell", bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: "LocationSearchCell")
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
            })
        }
    }
    
    func load() {
//        if location == "台北" {
//            infos = coreDataController.getInfoByLocation("台北", location2: "臺北")
//        }
//        else if location == "台中" {
//            infos = coreDataController.getInfoByLocation("台中", location2: "臺中")
//        }
//        else if location == "台南" {
//            infos = coreDataController.getInfoByLocation("台南", location2: "臺南")
//        }
//        else if location == "台東" {
//            infos = coreDataController.getInfoByLocation("台東", location2: "臺東")
//        }
//        else{
//            infos = coreDataController.getInfoByLocation(location, location2: location)
//        }
//        
//        for info in infos {
//            if (idCompare.range(of: info.modelId!) == nil) {
//                var temp = coreDataController.getModelById(info.modelId!)
//                model.append(temp[0])
//                finalInfos.append(info)
//                idCompare += info.modelId!
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as! LocationSearchTblViewCell
        cell.title.text = model[(indexPath as NSIndexPath).row].title!
        cell.address.text = finalInfos[(indexPath as NSIndexPath).row].location!
        cell.category = setCategoryImage(Int(model[(indexPath as NSIndexPath).row].category!), category: cell.category)
        if finalInfos[(indexPath as NSIndexPath).row].endTime! != "" {
            cell.time.text = finalInfos[(indexPath as NSIndexPath).row].startTime! + " ~ " + finalInfos[(indexPath as NSIndexPath).row].endTime!
        }
        else {
            cell.time.text = finalInfos[(indexPath as NSIndexPath).row].startTime!
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLocationDetail", sender: model[(indexPath as NSIndexPath).row].title!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.searchTitle = sender as! String
    }
    
    func setCategoryImage(_ categoryName:Int, category:UIImageView)->UIImageView{
        
        var image: UIImage = UIImage()
        switch categoryName {
        case 1:
            image = UIImage(named: "music")!
        case 2:
            image = UIImage(named: "drama")!
        case 3:
            image = UIImage(named: "dance")!
        case 4:
            image = UIImage(named: "family")!
        case 5:
            image = UIImage(named: "indieMusic")!
        case 6:
            image = UIImage(named: "exibition")!
        case 7:
            image = UIImage(named: "lecture")!
        case 8:
            image = UIImage(named: "movie")!
        case 11:
            image = UIImage(named: "entertainment")!
        case 13:
            image = UIImage(named: "competition")!
        case 14:
            image = UIImage(named: "competition")!
        case 15:
            image = UIImage(named: "other")!
        case 17:
            image = UIImage(named: "concert")!
        case 19:
            image = UIImage(named: "class")!
        default:
            image = UIImage(named: "unknown")!
        }
        
        category.image = image
        return category
    }

}
