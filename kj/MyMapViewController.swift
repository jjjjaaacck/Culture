//
//  ViewController.swift
//
//  Created by BurdieTai on 2015/10/19.
//  Copyright © 2015年 BurdieTai. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import SwiftyJSON
import MapKit

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

struct locationBasicInformation {
    var id: String
    var location: CLLocationCoordinate2D
    var distance: Double
    var title: String
    var address: String
}

class MyMapViewController: UIViewController, CLLocationManagerDelegate ,GMSMapViewDelegate{

    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var data = [MainData]()
    var locationDistances = [locationBasicInformation]()
    var markers = [GMSMarker]()
    var rangeCircle = GMSCircle()
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D() {
        didSet {
            setAllLocationMarkers()
        }
    }
    var radius: Double {
        get {
            return Double(slider.value * 20000 + Float(1000))
            
        }
        set {
            redrawCircle()
            resetNearLocation()
            radiusLabel.text = "\(Int(radius)) 公尺"
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            radiusLabel.text = "\(Int(radius)) 公尺"
        }
    }
    
    @IBOutlet weak var radiusLabel: UILabel!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        radius = Double(sender.value * 20000 + Float(1000))
        let range = translateCoordinate(coordinate: currentLocation, latitudeMeter: radius * 2, longitudeMeter: radius * 2)
        let bounds = GMSCoordinateBounds(coordinate: range.southWest, coordinate: range.northEast)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 5.0)
        mapViewYo.moveCamera(update)
    }
    
    @IBAction func sliderTouchUpOutside(_ sender: UISlider) {
        resetNearLocation()
    }
    
    @IBAction func sliderTouchUpInside(_ sender: UISlider) {
        resetNearLocation()
    }
    
    @IBOutlet var mapViewYo: GMSMapView! {
        didSet {
            mapViewYo.delegate = self
            mapViewYo.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        }
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem! {
        didSet {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCurrentPlace(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "nearByEvent", sender: nil)
    }
    
    func calculateDistance(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double{
        let radOriginLat = origin.latitude.degreesToRadians
        let radDestinationLat = destination.latitude.degreesToRadians
        let a = radOriginLat - radDestinationLat
        let b = origin.longitude.degreesToRadians - destination.longitude.degreesToRadians
        
        let distance = 2 * asin(sqrt(pow(sin(a * 0.5), 2) + cos(radOriginLat) * cos(radDestinationLat) * pow(sin(b * 0.5), 2))) * 6378137
        
        return distance
    }
    
    func translateCoordinate(coordinate: CLLocationCoordinate2D, latitudeMeter: Double, longitudeMeter: Double) -> (northEast: CLLocationCoordinate2D, southWest: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, CLLocationDistance(latitudeMeter), CLLocationDistance(longitudeMeter))
        let span = region.span
        let northEast = CLLocationCoordinate2D(latitude: coordinate.latitude + span.latitudeDelta / 2, longitude: coordinate.longitude + span.longitudeDelta / 2)
        let southWest = CLLocationCoordinate2D(latitude: coordinate.latitude - span.latitudeDelta / 2, longitude: coordinate.longitude - span.longitudeDelta / 2)
        
        return (northEast, southWest)
    }
    
    func fetchData() {
        let filter = NSPredicate(format: "ANY informations.latitude != 0 AND ANY informations.longitude != 0")
        RealmManager.sharedInstance.tryFetchMainDataByFilter(filter).continueWith {
            task in
            self.data = task.result as! [MainData]
        }
    }
    
    func setAllLocationMarkers() {
        for result in self.data {
            let origin = CLLocationCoordinate2DMake(result.informations[0].latitude, result.informations[0].longitude)
            let distance = self.calculateDistance(origin: origin, destination: self.currentLocation)
            let address = !result.informations.isEmpty || result.informations[0].location != "" ? result.informations[0].location : ""
            let information = (id: result.id, distance: distance)
            let marker = GMSMarker(position: origin)
            
            marker.icon = UIImage(named: "marker")
            marker.title = result.title
            marker.snippet = address
            marker.userData = information
            
            self.markers.append(marker)
        }
    }
    
    func redrawCircle() {
        let circleCenter = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
        rangeCircle.position = circleCenter
        rangeCircle.radius = CLLocationDistance(radius)
        rangeCircle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.03)
        rangeCircle.strokeColor = UIColor.red
        rangeCircle.map = mapViewYo
    }
    
    func resetNearLocation() {
        for marker in markers {
            let markerData = marker.userData as! (id: String, distance: Double)
            if markerData.distance <= self.radius {
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = self.mapViewYo
            }
            else {
                marker.map = nil
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapDetail" {
            let detailController: TransitionViewController = segue.destination as! TransitionViewController
            detailController.mainDataId = sender as! String
        }
        else {
            let nearByViewController = segue.destination as! NearByViewController
            nearByViewController.currentLocation = self.currentLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.distanceFilter = 500;
            locationManager.startUpdatingLocation()
            
            self.mapViewYo.isMyLocationEnabled = true
            self.mapViewYo.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
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
            
            mapViewYo.clear()
            redrawCircle()
            resetNearLocation()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.performSegue(withIdentifier: "showMapDetail", sender: (marker.userData as! (id: String, distance: Double)).id)
    }
}

