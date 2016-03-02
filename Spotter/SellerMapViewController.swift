//
//  SellerMapViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 3/1/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class SellerMapViewController: BaseMapViewController {

    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressSearchBar: UISearchBar!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        addressSearchBar.delegate = self
        loadMap()
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if saveButton === sender{
//            SellerEditMenuSingleton.sharedInstance.parkingCoordinates = CLLocationCoordinate2DMake(fetchedAddressLatitude, fetchedAddressLongitude)
//        }
//    }

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
    
    // GMSMapViewDelegate
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        fetchedAddressLatitude = coordinate.latitude
        fetchedAddressLongitude = coordinate.longitude
        mapView.clear()
        placeMarker(fetchedAddressLongitude, andLatitude: fetchedAddressLatitude, andTitle: "", andMapView: mapView)
    }
}

// BASE CLASS DELEGATES
extension SellerMapViewController {
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
    

    
    // UISeachBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
        //TODO: when presenting search bar, make sure to initialize the text with the previously searched address
    }
    
    // LocateOnTheMapDelegate
    func modelView(finishedWithValue: String) {
        geocodeAddress(finishedWithValue) { (status, success) -> Void in
            if success {
                self.placeMarker(self.fetchedAddressLongitude, andLatitude: self.fetchedAddressLatitude, andTitle: "", andMapView: self.mapView)
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
}
