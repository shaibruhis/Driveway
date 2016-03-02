//
//  BuyerMapViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 3/1/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase

class BuyerMapViewController: BaseMapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDriveways()
        // Do any additional setup after loading the view.
    }

    // Add parking markers on map
    func populateDriveways() {
        var drivewayList = [NSDictionary]()
        // Get a reference to our Users
        let ref = Firebase(url:"https://blinding-fire-154.firebaseio.com/Locations")
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in   // Use observeEventType if want to update in real time as database updates
            print("\(snapshot.value)")
            //            let drivewayDict = self.convertJSONToDictionary(String(snapshot.value))
            drivewayList = self.convertJSONToDictionary(snapshot)!
            print("\(drivewayList)")
            for spot in drivewayList {
                
                let lat = spot["Lat"] as! Double
                let lon = spot["Lon"] as! Double
                print ("\(lat, lon)")
                //TODO: set title to be spot.price
                self.placeMarker(lon, andLatitude: lat, andTitle: "", andMapView: self.mapView)
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Use observeSingleEventOfType if we only want to populate once
        //        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
        //            print(snapshot.value)
        //        })
    }

}
