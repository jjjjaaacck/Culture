//
//  MapView.swift
//  kj
//
//  Created by 劉 on 2016/6/10.
//  Copyright © 2016年 劉. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: UIView {
    
    var activityMap = GMSMapView()
    var latitude = 0.0
    var longitude = 0.0

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(latitude: Double, longitude: Double) {
        self.init(frame: CGRect.zero)
        
        addSubview(activityMap)
        
        activityMap.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        if latitude != 0.0 && longitude != 0.0 {
            self.latitude = latitude
            self.longitude = longitude
            setMap()
        }
    }

    func setMap() {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
        
//        activityMap = GMSMapView.mapWithFrame(CGRectMake(10, 10+15, view.frame.size.width-20, 160), camera: camera)
        activityMap = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        activityMap.accessibilityElementsHidden = true
        activityMap.settings.scrollGestures = false
        activityMap.settings.zoomGestures = true
        activityMap.settings.compassButton = true
        activityMap.isMyLocationEnabled = true
        activityMap.settings.myLocationButton = true
        activityMap.setMinZoom(8, maxZoom: 20)
        
//        showMarker(activityMap, coordinate: coordinate)
        
    }
    
    func showMarker(_ mapview: GMSMapView, coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        //marker.title = "Hello"
        //marker.snippet = "I'm fine"
        //marker.appearAnimation = kGMSMarkerAnimationPop
        //        marker.icon = resizeImage(UIImage(named: "map-marker.png")!,size:CGSizeMake(30.0, 30.0))
        marker.icon = UIImage(named: "marker")
        marker.map = mapview
    }
}
