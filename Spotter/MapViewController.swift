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

    var mapView = GMSMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        loadMap()
    }
    
    func loadMap() {
        mapView = GMSMapView(frame: CGRectZero)
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid, kGMSTypeTerrain, kGMSTypeNone
        mapView.mapType = kGMSTypeHybrid
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
        // Add marker for user's current location
        let position = CLLocationCoordinate2DMake(-31.868, 151.208) // position will be current location coordinates
        let usersCurrentLocationMarker = GMSMarker(position: position)
        usersCurrentLocationMarker.title = "Hello World"    // user's current location pin should have no title?
//        usersCurrentLocationMarker.icon = UIImage(named: "house")
        usersCurrentLocationMarker.opacity = 0.9
        usersCurrentLocationMarker.snippet = "I am currently Selected!"
        usersCurrentLocationMarker.map = mapView
        
        // Add parking markers on map
        // If you are creating several markers with the same image, use the same instance of UIImage for each of the markers. This helps improve the performance of your application when displaying many markers.
        // This image may have multiple frames. Additionally, the alignmentRectInsets property is respected, which is useful if a marker has a shadow or other unusable region.
//        for spot in parkingSpotsList {
//            let  position = CLLocationCoordinate2DMake(-31.868, 151.208) // position will be coordinates in ParkingSpot Model
//            let marker = GMSMarker(position: position)
//            marker.title = "Hello World"  // title will be price in ParkingSpot Model
//            marker.map = mapView
//        }
        self.view = mapView
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    // called when user grants or revokes location permission
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .AuthorizedWhenInUse {
//            
//            locationManager.startUpdatingLocation()
//            // draws a light blue dot where the user is located
//            mapView.myLocationEnabled = true
//            // adds button to bottom right of map that, when tapped, centers on user's location
//            mapView.settings.myLocationButton = true
//        }
//    }
    
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