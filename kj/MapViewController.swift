//
//  MapViewController.swift
//  kj
//
//  Created by 劉 on 2015/10/16.
//  Copyright © 2015年 劉. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    var tempCoordinate: [Double] = []
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    @IBAction func backButtonClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        let coordinate = CLLocationCoordinate2DMake(tempCoordinate[0], tempCoordinate[1])
        //print(coordinate.latitude)
        //print(coordinate.longitude)
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: navigationBar.frame.height, width: self.view.frame.width, height: self.view.frame.height - navigationBar.frame.height), camera: camera)
        mapView.accessibilityElementsHidden = true
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        
        mapView.animate(toBearing: 0)
        mapView.setMinZoom(5, maxZoom: 20)
        
        showMarker(mapView, coordinate: coordinate)
        self.view.addSubview(mapView)
        mapView.animate(with: GMSCameraUpdate.setTarget(coordinate))
        //self.view.frame = mapView.frame
        //self.view = mapView
    }
    
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        let markerC = CLLocationCoordinate2DMake(tempCoordinate[0], tempCoordinate[1])
        let bounds = GMSCoordinateBounds(coordinate: self.currentLocation.coordinate, coordinate: markerC)
        let update = GMSCameraUpdate.fit(bounds)
        mapView.animate(with: update)
        //print(getRadius())
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.distanceFilter = 500;
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            self.currentLocation = location
        }
        
    }
    
    func showMarker(_ mapview: GMSMapView, coordinate: CLLocationCoordinate2D)
    {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        //marker.appearAnimation = kGMSMarkerAnimationPop
        marker.icon = UIImage(named: "marker")
        marker.map = mapview
    }
    
    func getRadius()->CLLocationDistance{
        let currentL = locationManager.location
        
        let markerL = CLLocation(latitude: tempCoordinate[0], longitude: tempCoordinate[1])
        
        let radius = CLLocationDistance(markerL.distance(from: currentL!))
        
        return radius
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
