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
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
        // kGMSTypeTerrain, kGMSTypeNone
        mapView.mapType = kGMSTypeHybrid
        self.view = mapView
        print("\(mapView.myLocation)")
    }
}