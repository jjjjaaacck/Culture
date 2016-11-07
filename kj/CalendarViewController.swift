//
//  CalendarViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/16.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var model = [Model]()
    var data = [MainData]()
    
    var coreDataController = CoreDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        datePicker.addTarget(self, action: #selector(CalendarViewController.dateChange), for: UIControlEvents.valueChanged)
        let nib: UINib = UINib(nibName: "CalendarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "calendarCell")
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        // Do any additional setup after loading the view.
    }
    
    func dateChange() {
        getData()
    }
    
    func getData() {
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "yyyy/MM/dd"
//        let date = dateFormat.string(from: datePicker.date)
        model.removeAll()
        
        let filter = NSPredicate(format:"startDate <= %@ AND endDate >= %@", datePicker.date as CVarArg, datePicker.date as CVarArg)
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueOnSuccessWith{ task in
            self.data = task as! [MainData]
        }
//        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith { task in
//            self.data = task.result as! [MainData]
//            return nil
//        }
//        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith(successBlock: { (task) -> AnyObject? in
//            self.data = task.result as! [MainData]
//            return nil
//            })
//        infos = coreDataController.getInfoByDate(date)
        
        tableView.reloadData()
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        
        if !data.isEmpty {
            cell.title.text = data[indexPath.row].title
            cell.address.text = data[indexPath.row].informations[0].location
            setCategoryImage(Int(data[indexPath.row].category), category: cell.category)
            if let endDate = data[indexPath.row].endDate {
                cell.time.text = dateToString(date: data[indexPath.row].startDate!) + " ~ "
                    + dateToString(date: endDate)
            }
            else {
                cell.time.text = dateToString(date: data[indexPath.row].startDate!)
            }
        }
        
//        if !infos.isEmpty {
//            cell.title.text = model[(indexPath as NSIndexPath).row].title!
//            cell.address.text = infos[indexPath.row].location!
//            cell.category = setCategoryImage(Int(model[(indexPath as NSIndexPath).row].category!), category: cell.category)
//            if infos[indexPath.row].endTime! != "" {
//                cell.time.text = infos[indexPath.row].startTime! + " ~ " + infos[indexPath.row].endTime!
//            }
//            else {
//                cell.time.text = infos[indexPath.row].startTime!
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty {
            return 0
        }
        else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCalendarDetail", sender: model[(indexPath as NSIndexPath).row].title!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.searchTitle = sender as! String
    }
    
    func setCategoryImage(_ categoryName:Int, category:UIImageView) {
        
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
    }

    func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }

}
