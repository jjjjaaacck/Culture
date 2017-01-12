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
    var data = [LocationBasicInformation]()

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
        
        data.sort { (location1, location2) -> Bool in
            return location1.distance < location2.distance
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByCell", for: indexPath) as! nearByEventCell
        
        cell.titleLabel.text = data[indexPath.row].title
        cell.titleLabel.sizeToFit()
        cell.addressLabel.text = data[indexPath.row].address
        cell.distanceLabel.text = "距離 : \(Int(data[indexPath.row].distance)) 公尺"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showNearByDetail", sender: data[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transitionViewController = segue.destination as! TransitionViewController
        transitionViewController.mainDataId = sender as! String
    }
    
    func getRadius(_ latitude : CLLocationDegrees, longitude : CLLocationDegrees)->CLLocationDistance{
        let currentL = CLLocation(latitude: self.currentLocation.latitude, longitude: self.currentLocation.longitude)
        
        let markerL = CLLocation(latitude: latitude, longitude: longitude)
        
        let radius = CLLocationDistance(markerL.distance(from: currentL))
        
        return radius
    }
}
