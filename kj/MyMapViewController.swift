//
//  ViewController.swift
//
//  Created by BurdieTai on 2015/10/19.
//  Copyright © 2015年 BurdieTai. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class MyMapViewController: UIViewController,CLLocationManagerDelegate ,GMSMapViewDelegate{
    
    var placesClient: GMSPlacesClient?
    var placePicker: GMSPlacePicker?
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var currentLocation = CLLocationCoordinate2D()
    
    @IBOutlet var mapViewYo: GMSMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        mapViewYo.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapViewYo.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCurrentPlace(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "nearByEvent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nearByViewController = segue.destination as! NearByViewController
        nearByViewController.currentLocation = self.currentLocation
    }
    //
    //    func loadMap(_ coordinate : CLLocationCoordinate2D){
    //        if let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18){
    //            //mapViewYo = GMSMapView.mapWithFrame(self.mapViewYo.frame, camera: camera)
    //            //mapViewYo.accessibilityElementsHidden = true
    //            //mapViewYo.delegate = self
    //            //mapViewYo.settings.scrollGestures = true
    //            //mapViewYo.settings.zoomGestures = false
    //            //mapView.myLocationEnabled = true
    //            //mapView.settings.myLocationButton = true
    //            //mapViewYo.setMinZoom(8, maxZoom: 20)
    //            mapViewYo.settings.compassButton = true
    //            mapViewYo.animate(to: camera)
    //
    //        }
    //    }
    /*
     func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
     let geocoder = GMSGeocoder()
     geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
     if let address = response?.firstResult() {
     //let lines = address.lines as! [String]
     //self.addressLabel.text = lines.joinWithSeparator("\n")
     self.addressLabel.text = address.addressLine1()
     UIView.animateWithDuration(0.5) {
     self.addressLabel.layoutIfNeeded()
     }
     }
     }
     }
     
     func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
     reverseGeocodeCoordinate(position.target)
     }*/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.distanceFilter = 500;
            locationManager.startUpdatingLocation()
            
            self.mapViewYo.isMyLocationEnabled = true
            self.mapViewYo.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last
        {
            self.mapViewYo.camera = GMSCameraPosition(target:location.coordinate, zoom:15,bearing:0, viewingAngle:0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    deinit{
        mapViewYo.removeObserver(self, forKeyPath: "myLocation")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation : CLLocation = change?[NSKeyValueChangeKey.newKey] as! CLLocation
            
            self.currentLocation = myLocation.coordinate
            self.mapViewYo.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
            self.mapViewYo.settings.myLocationButton = true
            
            didFindMyLocation = true
            
            didFindMyLocation = true
            
        }
    }
}

