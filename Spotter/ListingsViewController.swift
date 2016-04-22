//
//  ListingsViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/12/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class ListingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listingsTableView: UITableView!
    
    var usersSpots = [Listing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listingsTableView.delegate = self;
        listingsTableView.dataSource = self;
        getUsersListingsIDs()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToListingsViewController(segue:UIStoryboardSegue){
        // Do nothing as we transition back to here when user cancels the "add new listing"
    }
    
    @IBAction func postListing(segue:UIStoryboardSegue){
        // TODO: add code to add listing to database.
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
    
//    func addAddressToListing(listing: Listing)
//    {
//        let lat = CLLocationDegrees(listing.lat)!
//        let lon = CLLocationDegrees(listing.lon)!
//        let coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        
//        let geocoder = GMSGeocoder()
//        geocoder.reverseGeocodeCoordinate(coords, completionHandler: { (response: GMSReverseGeocodeResponse!, error: NSError!) in
//            print(response.firstResult().lines[0],response.firstResult().lines[1])
//            listing.address = response.firstResult().lines[0] as! String
//            self.usersSpots.append(listing)
//            self.listingsTableView.reloadData()
//        })
//    }
    
    func getInfoForLisingID(listingID: String)
    {
        let ref = Firebase(url:"https://blinding-fire-154.firebaseio.com/Locations")
        let listingRef = ref.childByAppendingPath(listingID)
        // Attach a closure to read the data at our posts reference
        listingRef.observeEventType(.Value, withBlock: { snapshot in   // Use observeEventType if want to update in real time as database updates
            if snapshot.exists() {
                let tempdict = (snapshot.value as! NSDictionary)
                let listing = Listing(listingID: listingID, lat: "\(tempdict["Lat"] as! Float)", lon: "\(tempdict["Lon"] as! Float)", address: "\(tempdict["Address"]!)")
                self.usersSpots.append(listing)
                self.listingsTableView.reloadData()
            }
        }, withCancelBlock: { error in
            print(error.description)
        })

    }

    func getUsersListingsIDs()
    {
        // Get a reference to our Users
        let ref = Firebase(url:"https://blinding-fire-154.firebaseio.com/Users")
        let usersRef = ref.childByAppendingPath(ref.authData.uid)
        let usersSpotsRef = usersRef.childByAppendingPath("SpotsOwned")
//        print(usersSpotsRef)
        // Attach a closure to read the data at our posts reference
        usersSpotsRef.observeEventType(.Value, withBlock: { snapshot in   // Use observeEventType if want to update in real time as database updates
            print(snapshot.value)
            self.usersSpots.removeAll()
            if snapshot.exists() {
                let tempdict = (snapshot.value as! NSDictionary)
                for listingID in tempdict.allKeys as! [String] {
                    self.getInfoForLisingID(listingID)
                }
            }
        }, withCancelBlock: { error in
            print(error.description)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersSpots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listedSpotsCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = usersSpots[indexPath.row].address
        return cell
    }
    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    


    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let ref = Firebase(url:"https://blinding-fire-154.firebaseio.com")
            let usersRef = ref.childByAppendingPath("Users/\(ref.authData.uid)")
            let locationsRef = ref.childByAppendingPath("Locations")
            let listing = usersSpots[indexPath.row].listingID
            
            // remove from Locations
            locationsRef.childByAppendingPath(listing).removeValue()
            
            // remove from Users/uid/SpotsOwned
            usersRef.childByAppendingPath("SpotsOwned/\(listing)").removeValue()
            
            // remove from tableview
            usersSpots.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

}
