//
//  SellerEditAddressViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/23/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//


import Foundation
import UIKit
import GoogleMaps

class SellerEditAddressViewController: UIViewController {
    @IBOutlet var mapView: GMSMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad(){
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.mapType = kGMSTypeNormal
        mapView.delegate = self
        
    }
}

extension SellerEditAddressViewController: CLLocationManagerDelegate{
    // called when user grants or revokes location permission
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            // draws a light blue dot where the user is located
            mapView.myLocationEnabled = true
            // adds button to bottom right of map that, when tapped, centers on user's location
            mapView.settings.myLocationButton = true
        }
    }
    
    // executed when location manager receives new location data
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // updates map view to center around user's location
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // comment out if we want to follow user's location
            locationManager.stopUpdatingLocation()
        }
    }
}

extension SellerEditAddressViewController: GMSMapViewDelegate{
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        print(coordinate)
        mapView.clear()
        let marker = GMSMarker(position:coordinate)
        marker.title = "Placed marker here"
        marker.map = self.mapView
        
        
        
    }
}

//TODO: change custom ios target properties and add NSLocationWhenIsUsageDescription (key) with String being the value type and add description for why we need location.

//Something wrong with google api key/bundle identifier -> ClientParameterRequest failed