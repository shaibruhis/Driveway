//
//  MapViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/6/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()
    }
    
    func loadMap() {
        // Initialize mapView
//        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 12)
//        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        let mapView = GMSMapView(frame: CGRectZero)
        let target = CLLocationCoordinate2DMake(-31.868, 151.208)
        // Set location services
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        // Set visible region of map
        mapView.camera = GMSCameraPosition.cameraWithTarget(target, zoom:12)
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
        // kGMSTypeTerrain, kGMSTypeNone
        mapView.mapType = kGMSTypeHybrid
        
        // Add parking markers on map
//        for spot in parkingSpotsList {
            let  position = CLLocationCoordinate2DMake(-31.868, 151.208) // position will be coordinates in spot Model
            let marker = GMSMarker(position: position)
            marker.title = "Hello World"
            marker.map = mapView
//        }
        
        self.view = mapView
        print("\(mapView.myLocation)")
    
    }
    
    
}