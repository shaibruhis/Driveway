//
//  SellerEditMenu.swift
//  Spotter
//
//  Created by Christopher Chan on 2/15/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation


class SellerEditMenu: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var menuArray = [String]()
    @IBOutlet var saveListingButton: UIBarButtonItem!
    
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
        if(SellerEditMenuSingleton.sharedInstance.checkAllCompletion()){
            self.saveListingButton.enabled = true
        }
    }
    
    @IBAction func returnToSellerEditMenu(Segue: UIStoryboardSegue){
        if(Segue.identifier == "saveAddressSegue"){
            if let sellerEditAddressViewController = Segue.sourceViewController as? SellerEditAddressViewController{
                SellerEditMenuSingleton.sharedInstance.parkingCoordinates = sellerEditAddressViewController.spotLocation
            } //extra security, just in case for some reason user can press save even without selecting an address
        }
        if(Segue.identifier == "savePriceSegue"){
            if let sellerEditPriceViewController = Segue.sourceViewController as? SellerEditPriceViewController{
                SellerEditMenuSingleton.sharedInstance.price = sellerEditPriceViewController.spotPrice
                print(SellerEditMenuSingleton.sharedInstance.price)
            }
        }
        
        if(SellerEditMenuSingleton.sharedInstance.checkAllCompletion()){
            saveListingButton.enabled = true
        }
        else{
            saveListingButton.enabled = false
        }
        
        //TODO: Check for submenu completion every time we return to seller edit menu to place "checks" for completed submenus
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        SellerEditMenuSingleton.sharedInstance.resetValues()
    }


    
}
//TODO: Make sellereditmenu contain a container view which houses a tableviewcontroller in order to use static cell. Use delegation when cell is selected to change parentView via segue.