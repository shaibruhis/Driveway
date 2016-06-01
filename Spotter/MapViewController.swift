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

var lat : Double = 0
var lon : Double = 0
var address : String = "null"
var firstName : String = "null"
var price : String = "null"
var phoneNumber : String = "null"
var spotId : String = "null"

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
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {




        var secondVC: BuySpotListingViewController = segue.destinationViewController as! BuySpotListingViewController
        
        secondVC.lat = lat
        secondVC.lon = lon
        secondVC.address = address
        secondVC.price = price
        secondVC.firstName = firstName
        secondVC.phoneNumber = phoneNumber
        secondVC.spotId = spotId
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        searchResultController.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadMap()
    }
    
    @IBAction func returnToMapView(segue:UIStoryboardSegue){
    
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
        mapView.mapType = kGMSTypeNormal
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            // draws a light blue dot where the user is located
            mapView.myLocationEnabled = true
            // adds button to bottom right of map that, when tapped, centers on user's location
            mapView.settings.myLocationButton = true
        }
        
        self.view = mapView
        self.mapView.delegate = self
        populateDriveways()
    }
    

    func convertJSONToDictionary(snapshot: FDataSnapshot) -> [NSDictionary]? {

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
            self.mapView.clear();
            drivewayList = self.convertJSONToDictionary(snapshot)!
            for spot in drivewayList {
                if(spot["Is Available"] as! String == "True"){

                    print (spot)
                    let spotLat = spot["Lat"] as! Double
                    let spotLon = spot["Lon"] as! Double
                    let spotAddress = spot["Address"] as! String
                    let spotFirstName = spot["First Name"] as! String
                    let spotPrice = spot["Price"] as! String
                    let spotPhoneNumber = spot["Phone Number"] as! String
                    let spotId = spot["SpotID"] as! String
                    let marker = GMSMarker(position:CLLocationCoordinate2DMake(spotLat, spotLon))
                    let markerInfo = MarkerInfo(inputAddress: spotAddress, inputFirstName: spotFirstName, inputLat: spotLat, inputLon: spotLon, inputPrice: spotPrice, inputPhone: spotPhoneNumber, inputSpotId: spotId)
                    marker.userData = markerInfo

                    marker.map = self.mapView
                
                }
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    

    

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

        lat = (marker.userData as! MarkerInfo).lat!
        lon = (marker.userData as! MarkerInfo).lon!
        address = (marker.userData as! MarkerInfo).address
        firstName = (marker.userData as! MarkerInfo).ownerFirstName
        price = (marker.userData as! MarkerInfo).price
        phoneNumber = (marker.userData as! MarkerInfo).phone
        spotId = (marker.userData as! MarkerInfo).spotId
        performSegueWithIdentifier("Spot Listing Segue", sender: self)
        return true
    }
}


// MARK: - LocateOnTheMap
extension MapViewController: LocateOnTheMap {
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {

        // All the code inside this method is done explicitly from within the main thread. This is because the caller of this method was running in a background thread, and since all UI work (including the map stuff) should be performed on the main queue, we need to switch to UI thread before drawing to the map
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)

            marker.title = title
            marker.map = self.mapView
        }
    }
}


