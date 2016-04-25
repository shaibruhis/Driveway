//
//  SellerEditMenu.swift
//  Spotter
//
//  Created by Christopher Chan on 2/15/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase


class SellerEditMenu: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var menuArray = [String]()
    @IBOutlet var saveListingButton: UIBarButtonItem!
    @IBOutlet weak var cancelListingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
//        menuArray = ["Parking Type", "Address", "Parking Dimensions", "Price", "Availability"]
        menuArray = ["Address", "Price"]

    }
    
    func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sellerListingEditCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segueIdentifier = "Seller \(menuArray[indexPath.row]) Segue"
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
    
    func checkForCompletion(){
        if(SellerEditMenuSingleton.sharedInstance.checkAddressCompletion()){
            // place check mark on the right within the address cell
        }
        if(SellerEditMenuSingleton.sharedInstance.checkPriceCompletion()){
            // place check mark on the right of the price cell
        }
    }
    
    @IBAction func returnToSellerEditMenu(Segue: UIStoryboardSegue){
        //call checkforcompletion here
        if(SellerEditMenuSingleton.sharedInstance.checkAllCompletion()){
            saveListingButton.enabled = true
        }
        else{
            saveListingButton.enabled = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === cancelListingButton{
            SellerEditMenuSingleton.sharedInstance.resetValues()
        }
        if sender === saveListingButton{
            let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
            let userref = Firebase(url: "https://blinding-fire-154.firebaseio.com/Users/" + ref.authData.uid)

            
            userref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                //Setting the text boxes to display their respective attributes (First, Last, and Phone Number
                SellerEditMenuSingleton.sharedInstance.firstName = snapshot.value["First Name"] as? String
                SellerEditMenuSingleton.sharedInstance.lastName = snapshot.value["Last Name"] as? String
                SellerEditMenuSingleton.sharedInstance.phoneNumber = snapshot.value["Phone Number"] as? String
                let newLocation = ["Lat": SellerEditMenuSingleton.sharedInstance.parkingCoordinates!.latitude, "Lon": SellerEditMenuSingleton.sharedInstance.parkingCoordinates!.longitude, "Price": SellerEditMenuSingleton.sharedInstance.price!, "Owner": ref.authData.uid, "First Name" :  SellerEditMenuSingleton.sharedInstance.firstName!, "Phone Number" :  SellerEditMenuSingleton.sharedInstance.phoneNumber!, "Address":SellerEditMenuSingleton.sharedInstance.address!]
                //Get the data from the Text Box and putting them into Firebase
                
                //Make the branch "Users" in the database
                let locationsRef = ref.childByAppendingPath("Locations")
                //Auto-Generate a User ID
                let newLocationRef = locationsRef.childByAutoId()
                //write the values to the database
                newLocationRef.setValue(newLocation)
                
                //then get the auto generated uid and save it to that user's list of owned spots
                
                
                userref.childByAppendingPath("SpotsOwned").childByAppendingPath(newLocationRef.key).setValue(newLocationRef.key)
                
                
                SellerEditMenuSingleton.sharedInstance.resetValues()

            })

                
            
        }//need to also post to database
    }


    
}
//TODO: Make sellereditmenu contain a container view which houses a tableviewcontroller in order to use static cell. Use delegation when cell is selected to change parentView via segue.