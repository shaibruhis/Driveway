//
//  MapTasks.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/23/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import GoogleMaps

class MapTasks: NSObject {
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    var lookupAddressResults = [String: AnyObject]()
    var fetchedFormattedAddress = String()
    var fetchedAddressLongitude = Double()
    var fetchedAddressLatitude = Double()
    
    override init() {
        super.init()
    }

    func geocodeAddress(address: String!, withCompletionHandler completionHandler: ((status: String, success: Bool) -> Void)?) {
        if let lookupAddress = address {
            // build URL with passed in address
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let geocodeURL = NSURL(string: geocodeURLString)
            
            // asyncronously fetch data
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let geocodingResultsData = NSData(contentsOfURL: geocodeURL!)
                
//                var error: NSError?
                do {
                    let dictionary: Dictionary<String, AnyObject> = try NSJSONSerialization.JSONObjectWithData(geocodingResultsData!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                    // Get the response status.
                    let status = dictionary["status"] as! String
                    
                    if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<String, AnyObject>>
                        self.lookupAddressResults = allResults[0]
                        
                        // Keep the most important values.
                        self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
                        let geometry_location = (self.lookupAddressResults["geometry"] as! Dictionary<String, AnyObject>)["location"] as! Dictionary<String,Double>
                        self.fetchedAddressLongitude = geometry_location["lng"]! as Double
                        self.fetchedAddressLatitude = geometry_location["lat"]! as Double
                        
                        //                        completionHandler(status: status, success: true)
                    }
                    else {
                        //                        completionHandler(status: status, success: false)
                    }

                }
                catch let error as NSError {
                    print(error)
//                    completionHandler(status: "", success: false)
                }
            })
        }
        else {
//            completionHandler(status: "No valid address.", success: false)
        }
    }
    
    func reverseGeocodeCoordinates(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                print("\(address)")
            }
        }
    }

}