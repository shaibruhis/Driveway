//
//  MapViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/6/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

//let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

class MapViewController: BaseViewController {

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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchResultController.delegate = self

        
        loadMap()
    }
    
    @IBAction func returnToMapView(segue:UIStoryboardSegue){
        // Do nothing as we transition back to here when user cancels the "add new listing"
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
//                print("\(address)")
            }
        }
    }
    
    // If you are creating several markers with the same image, use the same instance of UIImage for each of the markers. This helps improve the performance of your application when displaying many markers.
    // This image may have multiple frames. Additionally, the alignmentRectInsets property is respected, which is useful if a marker has a shadow or other unusable region.
    func placeMarker(spotAddress: String, mapView: GMSMapView) {
        geocodeAddress(spotAddress, withCompletionHandler: nil)
        let coordinates = CLLocationCoordinate2DMake(fetchedAddressLatitude, fetchedAddressLongitude)
        let marker = GMSMarker(position: coordinates)
//        marker.setInfo()
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
        self.mapView.delegate = self
        populateDriveways()
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
    
    
    // example address: https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=YOUR_API_KEY
    func makeAddress(spot: NSDictionary) -> String {
        let houseNumberPlusStreet = spot["Address"] as? String
        let city = spot["City"] as? String
        let state = spot["State"] as? String
        let spotAddress = "\(houseNumberPlusStreet), \(city), \(state)"
        return spotAddress
    }
    
    // Add parking markers on map
    func populateDriveways() {
        
        var drivewayList = [NSDictionary]()
        // Get a reference to our Users
        let ref = Firebase(url:"https://blinding-fire-154.firebaseio.com/Locations")
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in   // Use observeEventType if want to update in real time as database updates
//                        print("\(snapshot.value)")
//            let drivewayDict = self.convertJSONToDictionary(String(snapshot.value))
            drivewayList = self.convertJSONToDictionary(snapshot)!
//            print("\(drivewayList)")
            for spot in drivewayList {
//                let spotAddress = self.makeAddress(spot)
//                print ("\(spotAddress)")
//                self.placeMarker(spotAddress, mapView: self.mapView)
//                print ("\(spot["Lat"]!, spot["Lon"]!)")
                let lat = spot["Lat"] as! Double
                let lon = spot["Lon"] as! Double
                let firstName = spot["First Name"] as! String
                let price = spot["Price"] as! String
                let phoneNumber = spot["Phone Number"] as! String
                let marker = GMSMarker(position:CLLocationCoordinate2DMake(lat, lon))
                var markerInfo = MarkerInfo(inputFirstName: firstName, inputLat: lat, inputLon: lon, inputPrice: price, inputPhone: phoneNumber)
                marker.userData = markerInfo
                marker.map = self.mapView
                
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Use observeSingleEventOfType if we only want to populate once
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//        })
    }
    
    
    @IBAction func showSearchBarAction(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
//        
//        let placesClient = GMSPlacesClient()
//        placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error:NSError?) -> Void in
//            self.resultsArray.removeAll()
//            if results == nil {
//                return
//            }
//            for result in results!{
//                if let result = result as? GMSAutocompletePrediction{
//                    self.resultsArray.append(result.attributedFullText.string)
//                }
//            }
//            self.searchResultController.reloadDataWithArray(self.resultsArray)
//        }
//    }
}


// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
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
extension MapViewController: GMSMapViewDelegate {
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        print( (marker.userData as! MarkerInfo).ownerFirstName )
        performSegueWithIdentifier("Spot Listing Segue", sender: self)
        return true
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinates(position.target)
    }		

}



// MARK: - UISeachBarDelegate
extension MapViewController: UISearchBarDelegate {
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
extension MapViewController: LocateOnTheMap {
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {

        // All the code inside this method is done explicitly from within the main thread. This is because the caller of this method was running in a background thread, and since all UI work (including the map stuff) should be performed on the main queue, we need to switch to UI thread before drawing to the map
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)

            //            let camera  = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 10)
            //            self.mapView.camera = camera

            marker.title = title
            marker.map = self.mapView
        }
    }
}


