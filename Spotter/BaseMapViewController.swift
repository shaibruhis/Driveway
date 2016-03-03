//
//  BaseMapViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/6/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

//let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

class BaseMapViewController: BaseMenuViewController {

    var mapView = GMSMapView()
    let locationManager = CLLocationManager()
    let searchResultController = SearchResultsController()
    
    var resultsArray = [String]()

    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    var lookupAddressResults = [String: AnyObject]()
    var fetchedFormattedAddress = String()
    var fetchedAddressLongitude = Double()
    var fetchedAddressLatitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMap()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchResultController.delegate = self
        // must come after loadMap() because mapView gets set in loadMap()
        mapView.delegate = self

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
    
    // If you are creating several markers with the same image, use the same instance of UIImage for each of the markers. This helps improve the performance of your application when displaying many markers.
    // This image may have multiple frames. Additionally, the alignmentRectInsets property is respected, which is useful if a marker has a shadow or other unusable region.
    func placeMarker(lon: Double, andLatitude lat: Double, andTitle title: String, andMapView mapView: GMSMapView) {
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        let marker = GMSMarker(position: coordinates)
        marker.title = title  // title will be price in ParkingSpot Model
        marker.map = mapView
    }
    

    
    func loadMap() {
        mapView = GMSMapView(frame: CGRectZero)
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid, kGMSTypeTerrain, kGMSTypeNone
        mapView.mapType = kGMSTypeHybrid
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            // draws a light blue dot where the user is located
            mapView.myLocationEnabled = true
            // adds button to bottom right of map that, when tapped, centers on user's location
            mapView.settings.myLocationButton = true
        }
        
        // Add marker for user's current location
//        let position = CLLocationCoordinate2DMake(-31.868, 151.208) // position will be current location coordinates
//        let usersCurrentLocationMarker = GMSMarker(position: position)
//        usersCurrentLocationMarker.title = "Hello World"    // user's current location pin should have no title?
////        usersCurrentLocationMarker.icon = UIImage(named: "house")
//        usersCurrentLocationMarker.opacity = 0.9
//        usersCurrentLocationMarker.snippet = "I am currently Selected!"
//        usersCurrentLocationMarker.map = mapView
        
        self.view = mapView
    }
    

    // THIS FUNCTION SHOULDN'T BE IN THIS VC
    func convertJSONToDictionary(snapshot: FDataSnapshot) -> [NSDictionary]? {
//    func convertJSONToDictionary(text: String) -> [String:AnyObject]? {
        // THIS IS THE PROPER WAY TO DO THIS I BELIEVE
//        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String:AnyObject]
//                return json
//            } catch {
//                print("Something went wrong")
//            }
//        }
//        return nil
        
        // BUT THIS CURRENTLY WORKS...
        var tempItems = [NSDictionary]()
        for item in snapshot.children {
            let child = item as! FDataSnapshot
            let dict = child.value as! NSDictionary
            tempItems.append(dict)
        }
        return tempItems
    }
    

    
    
    @IBAction func showSearchBarAction(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
}


// MARK: - CLLocationManagerDelegate
extension BaseMapViewController: CLLocationManagerDelegate {
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

// MARK: - GMSMapViewDelegate
extension BaseMapViewController: GMSMapViewDelegate {
//    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
//        reverseGeocodeCoordinates(position.target)
//    }
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        print("Implement in base class!")
    }
}

// MARK: - UISeachBarDelegate
extension BaseMapViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
            
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
    }
}


// MARK: - LocateOnTheMap
extension BaseMapViewController: LocateOnTheMap {
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        // All the code inside this method is done explicitly from within the main thread. This is because the caller of this method was running in a background thread, and since all UI work (including the map stuff) should be performed on the main queue, we need to switch to UI thread before drawing to the map
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.placeMarker(lon, andLatitude: lat, andTitle: title, andMapView: self.mapView)
        }
    }
}


