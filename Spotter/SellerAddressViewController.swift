//
//  SellerAddressViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/23/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//


import Foundation
import UIKit
import GoogleMaps
import Firebase

class SellerAddressViewController: BaseMapViewController {
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressSearchBar: UISearchBar!

    override func viewDidLoad(){
        super.viewDidLoad()
        
        addressSearchBar.delegate = self
        
    }
    
    var spotLocation: CLLocationCoordinate2D?

    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if saveButton === sender{
//            SellerEditMenuSingleton.sharedInstance.parkingCoordinates = spotLocation
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
 }

//extension SellerAddressViewController{
//    // UISeachBarDelegate
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        let searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchBar.delegate = self
//        self.presentViewController(searchController, animated: true, completion: nil)
//        //TODO: when presenting search bar, make sure to initialize the text with the previously searched address
//    }
//}