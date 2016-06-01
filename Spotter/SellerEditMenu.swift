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
        menuArray = ["Address", "Price", "Available Times"]

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
    
    func getCurrentTimeAndCheck() -> String{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        
        let startTime = SellerEditMenuSingleton.sharedInstance.startTime!
        let endTime = SellerEditMenuSingleton.sharedInstance.endTime!
        
        let spotTimeFormatter = NSDateFormatter()
        spotTimeFormatter.dateFormat = "h:mm a"
        let startTimeDate = spotTimeFormatter.dateFromString(startTime)
        let endTimeDate = spotTimeFormatter.dateFromString(endTime)
        
        let startComponents = calendar.components([.Hour, .Minute], fromDate: startTimeDate!)
        let endComponents = calendar.components([.Hour, .Minute], fromDate: endTimeDate!)
        let nowComponents = calendar.components([.Hour, .Minute], fromDate: date)
        
        let startHour = startComponents.hour
        let startMinute = startComponents.minute + 60 * startHour
        let endHour = endComponents.hour
        let endMinute = endComponents.minute + 60 * endHour
        let nowHour = nowComponents.hour
        let nowMinute = nowComponents.hour + 60 * nowHour
        
        if(startMinute < endMinute){
            if(nowMinute >= startMinute && nowMinute < endMinute){
                return "True"
            }
            else{
                return "False"
            }
        }
        else if(startMinute == endMinute){
            return "True"
        }
        else{
            if(nowMinute > startMinute && nowMinute > endMinute){
                return "True"
            }
            else if(nowMinute < startMinute && nowMinute < endMinute){
                return "True"
            }
            else{
                return "False"
            }
        } //startMinute>endMinute
//        if((startHour < endHour) || (startHour == endHour && startMinute < endMinute)){
//            if(nowHour > startHour && nowHour < endHour){
//                return "True"
//            }
//            else if(nowHour == startHour && nowMinute >= startMinute && nowHour < endHour){
//                return "True"
//            }
//            else if(nowHour ==  startHour && nowMinute >= startMinute && nowHour == endHour && nowMinute <= endMinute){
//                return "True"
//            }// ex: start: 12:05 now: 12:06
//            else if(nowHour == endHour && nowMinute < endMinute && nowHour > startHour){
//                return "True"
//            }// ex: end: 12:07 now: 12:06
//            else if(nowHour == endHour && nowMinute < endMinute && nowHour == startHour && nowMinute > startMinute){
//                return "True"
//            }
//            else{
//                return "False"
//            }
//        }//if the end time doesn't go into the next day
//        else if(startHour == endHour && startMinute == endMinute){
//            return "True"
//        }//no end time
//        else{
//            if(nowHour > startHour && nowHour > endHour){
//                return "True"
//            }
//            
//            else if(nowHour < startHour && nowHour < endHour){
//                return "True"
//            }
//            else if(nowHour ==  startHour && nowMinute >= startMinute){
//                return "True"
//            }
//            else if(nowHour == endHour && nowMinute < endMinute){
//                return "True"
//            }
//            else{
//                return "False"
//            }
//        }// else the end time goes into the next day
        // ex: start: 1:30AM end: 1:28AM
        
        
    } //gets current time and checks if its past starttime and before endtime
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === cancelListingButton{
            SellerEditMenuSingleton.sharedInstance.resetValues()
        }
        if sender === saveListingButton{
            let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
            let userref = Firebase(url: "https://blinding-fire-154.firebaseio.com/Users/" + ref.authData.uid)

            //Make the branch "Users" in the database
            let locationsRef = ref.childByAppendingPath("Locations")
            //Auto-Generate a User ID
            let newLocationRef = locationsRef.childByAutoId()
            
            userref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                //Setting the text boxes to display their respective attributes (First, Last, and Phone Number
                
                let isAvailable = self.getCurrentTimeAndCheck()
                
                SellerEditMenuSingleton.sharedInstance.firstName = snapshot.value["First Name"] as? String
                SellerEditMenuSingleton.sharedInstance.lastName = snapshot.value["Last Name"] as? String
                SellerEditMenuSingleton.sharedInstance.phoneNumber = snapshot.value["Phone Number"] as? String
                let newLocation = ["Lat": SellerEditMenuSingleton.sharedInstance.parkingCoordinates!.latitude, "Lon": SellerEditMenuSingleton.sharedInstance.parkingCoordinates!.longitude, "Price": SellerEditMenuSingleton.sharedInstance.price!, "Owner": ref.authData.uid, "First Name" :  SellerEditMenuSingleton.sharedInstance.firstName!, "Phone Number" :  SellerEditMenuSingleton.sharedInstance.phoneNumber!, "Address":SellerEditMenuSingleton.sharedInstance.address!, "Start Time":SellerEditMenuSingleton.sharedInstance.startTime!, "End Time":SellerEditMenuSingleton.sharedInstance.endTime!, "Is Available": isAvailable, "Rented Until":"-1", "SpotID":newLocationRef.key!]
                //Get the data from the Text Box and putting them into Firebase
                
                
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