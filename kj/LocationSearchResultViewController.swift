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
    var data = [MainData]()
    var model = [Model]()
    var infos = [Info]()
    var finalInfos = [Info]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
//            DispatchQueue.main.async(execute: {
                self.load()
                self.titleBar.topItem?.title = self.location
                self.tableView.backgroundColor =  UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
                let nib: UINib = UINib(nibName: "LocationSearchCell", bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: "LocationSearchCell")
                
                self.tableView.dataSource = self
                self.tableView.delegate = self
//            })
//        }
    }
    
    func load() {
        
        var filter = NSPredicate()
        if location == "台北" {
            filter = NSPredicate(format: "ANY informations.location CONTAINS '台北' OR ANY informations.location CONTAINS '臺北'")
        }
        else if location == "台中" {
            filter = NSPredicate(format: "ANY informations.location CONTAINS '台中' OR ANY informations.location CONTAINS '臺中'")
        }
        else if location == "台南" {
            filter = NSPredicate(format: "ANY informations.location CONTAINS '台南' OR ANY informations.location CONTAINS '臺南'")
        }
        else if location == "台東" {
            filter = NSPredicate(format: "ANY informations.location CONTAINS '台東' OR ANY informations.location CONTAINS '臺東'")
        }
        else{
            filter = NSPredicate(format: "ANY informations.location CONTAINS %@", location)
        }
        
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueOnSuccessWith{ task in
            self.data = task as! [MainData]
        }
        
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
        cell.title.text = data[indexPath.row].title
        cell.address.text = data[indexPath.row].informations[0].location
        cell.category = setCategoryImage(Int(data[indexPath.row].category), category: cell.category)
        cell.time.text = data[indexPath.row].informations[0].endTime == nil ? dateToString(date: data[indexPath.row].informations[0].startTime!) : dateToString(date: data[indexPath.row].informations[0].startTime!) + " ~ " + dateToString(date: data[indexPath.row].informations[0].endTime!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showLocationDetail", sender: data[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.mainDataId = sender as! String
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
    
    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.string(from: date)
    }

}
