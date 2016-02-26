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
import Firebase

class SellerEditAddressViewController: UIViewController {
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressSearchBar: UISearchBar!
    
    var spotLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let searchResultController = SearchResultsController()
    var resultsArray = [String]()
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    var lookupAddressResults = [String: AnyObject]()
    var fetchedFormattedAddress = String()
    var fetchedAddressLongitude = Double()
    var fetchedAddressLatitude = Double()



    override func viewDidLoad(){
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.mapType = kGMSTypeHybrid
        mapView.delegate = self
        addressSearchBar.delegate = self
        searchResultController.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender{
            let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
            //Get the data from the Text Box and putting them into Firebase

//            var newUser = ["First Name": firstName.text!, "Last Name": lastName.text!, "Phone Number": phoneNumber.text!, "Email": emailAddress.text!]
            let newLocation = ["Lat": fetchedAddressLatitude, "Lon": fetchedAddressLongitude]
            //Make the branch "Users" in the database
            let locationsRef = ref.childByAppendingPath("Locations")
            //Auto-Generate a User ID
            let newLocationRef = locationsRef.childByAutoId()
            //write the values to the database
            newLocationRef.setValue(newLocation)

        }//will not happen if user has not chosen a location
        
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
    
    func placeMarker(coordinate: CLLocationCoordinate2D) {
        spotLocation = coordinate
        mapView.clear()
        let marker = GMSMarker(position:spotLocation!)
        marker.title = "Placed marker here"
        marker.map = self.mapView
        self.saveButton.enabled = true
    }
    
}

extension SellerEditAddressViewController: GMSMapViewDelegate{
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        fetchedAddressLatitude = coordinate.latitude
        fetchedAddressLongitude = coordinate.longitude
        placeMarker(coordinate)
    }
}

// MARK: - UISeachBarDelegate
extension SellerEditAddressViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        //TODO: when presenting search bar, make sure to initialize the text with the previously searched address
    }
    
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
                        self.spotLocation = CLLocationCoordinate2DMake(self.fetchedAddressLatitude, self.fetchedAddressLongitude)
                        completionHandler!(status: status, success: true)
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

}


// MARK: - LocateOnTheMap
extension SellerEditAddressViewController: LocateOnTheMap {
    func modelView(finishedWithValue: String) {
        geocodeAddress(finishedWithValue) { (status, success) -> Void in
            if success {
                self.placeMarker(self.spotLocation!)
                // CATransaction needed for animation duration of changing map camera
                CATransaction.begin()
                CATransaction.setValue(NSNumber(float: 1.0), forKey: kCATransactionAnimationDuration)
                // change the camera, set the zoom, whatever.  Just make sure to call the animate* method.
                self.mapView.animateToCameraPosition(GMSCameraPosition.cameraWithLatitude(self.fetchedAddressLatitude, longitude: self.fetchedAddressLongitude, zoom: 15))
                CATransaction.commit()
                self.addressSearchBar.text = self.fetchedFormattedAddress
             }
        }
    }
    
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

//TODO: change custom ios target properties and add NSLocationWhenIsUsageDescription (key) with String being the value type and add description for why we need location.

//Something wrong with google api key/bundle identifier -> ClientParameterRequest failed