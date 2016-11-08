//
//  NearByViewController.swift
//  googlemap4
//
//  Created by BurdieTai on 2015/10/21.
//  Copyright © 2015年 BurdieTai. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class NearByViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var currentLocation = CLLocationCoordinate2D()
    var coreDataController = CoreDataController()
    
    var data = [MainData]()
    
//    var model = [Model]()
//    var infos = [Info]()
//    var finalInfos = [Info]()
//    var idCompare = ""
    
    @IBOutlet var tableView: UITableView!
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        let nib = UINib(nibName: "nearByEventCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NearByCell")
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        //print(currentLocation.latitude,currentLocation.longitude)
        let filter = NSPredicate(format: "ANY informations.latitude BETWEEN {%@, %@} AND ANY informations.longitude BETWEEN {%@, %@}", currentLocation.latitude - 0.01, currentLocation.latitude + 0.01, currentLocation.longitude - 0.01, currentLocation.longitude + 0.01)
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueOnSuccessWith{ task in
            self.data = task as! [MainData]
        }
//        infos = coreDataController.getNearByCoordinates(currentLocation.latitude, clongtitude: currentLocation.longitude)
    
//        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getData() {
//        for info in infos {
//            if (idCompare.range(of: info.modelId!) == nil) {
//                var temp = coreDataController.getModelById(info.modelId!)
//                model.append(temp[0])
//                finalInfos.append(info)
//                idCompare += info.modelId!
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByCell", for: indexPath) as! nearByEventCell
        
        cell.eventName.text = data[indexPath.row].title
//        cell.eventName.text = self.model[(indexPath as NSIndexPath).row].title!
        cell.eventName.sizeToFit()
        cell.eventLocation.text = data[indexPath.row].informations[0].location
//        cell.eventLocation.text = self.finalInfos[(indexPath as NSIndexPath).row].location!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNearByDetail", sender: data[indexPath.row].title)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.searchTitle = sender as! String
    }
    
    func getRadius(_ latitude : CLLocationDegrees, longitude : CLLocationDegrees)->CLLocationDistance{
        let currentL = CLLocation(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        
        let markerL = CLLocation(latitude: latitude, longitude: longitude)
        
        let radius = CLLocationDistance(markerL.distance(from: currentL))
        
        return radius
    }
}
