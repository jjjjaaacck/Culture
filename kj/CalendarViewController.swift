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
    var alertLabel = UILabel()
    var data = [MainData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        self.view.addSubview(alertLabel)
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        datePicker.addTarget(self, action: #selector(CalendarViewController.getData), for: UIControlEvents.valueChanged)
        let nib: UINib = UINib(nibName: "CalendarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "calendarCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        alertLabel.text = "這個時間沒有活動喔"
        alertLabel.isHidden = true
        alertLabel.sizeToFit()
        alertLabel.snp.makeConstraints { (make) in
            make.center.equalTo(tableView)
        }
        
        getData()
    }
    
    func getData() {
        
        let filter = NSPredicate(format:"startTime <= %@ AND endTime >= %@", datePicker.date as CVarArg, datePicker.date as CVarArg)
        RealmManager.sharedInstance.tryFetchMainDataWithFilterInformation(filter).continueOnSuccessWith{ task in
            self.data = Array(task as! Set<MainData>)
            self.alertLabel.isHidden = true
            }.continueOnErrorWith { task in
                self.data.removeAll()
                self.alertLabel.isHidden = false
        }
        
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
            cell.address.text = data[indexPath.row].informations[0].location == "" ? "沒有提供地點喔～" : data[indexPath.row].informations[0].location
            setCategoryImage(Int(data[indexPath.row].category), category: cell.category)
            
            cell.time.text = (data[indexPath.row].endDate != nil ) ?
                dateToString(date: data[indexPath.row].startDate!) + " ~ "
                + dateToString(date: data[indexPath.row].endDate!) : dateToString(date: data[indexPath.row].startDate!)
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showCalendarDetail", sender: data[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.mainDataId = sender as! String
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
