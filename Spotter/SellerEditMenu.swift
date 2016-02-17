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
    
    override func viewDidLoad() {
        menuArray = ["Parking Type", "Address", "Space Dimensions", "Price", "Availability"]
    }
    
    @IBAction func cancelToSellerEditMenuViewController(Segue: UIStoryboardSegue){
        //Do nothing
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
    
    // TODO: make the 5 cells fill screen
}