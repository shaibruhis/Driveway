//
//  ParkingType.swift
//  Spotter
//
//  Created by Christopher Chan on 2/16/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation

class ParkingType: UITableViewController{
    var menuArray = [String]()
    
    override func viewDidLoad() {
        menuArray = ["Driveway", "Outdoor Lot", "Indoor Garage", "Insert Parking Type Here #1", "Insert Parking Type Here #2"]
    }
    
    override func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sellerParkingTypeCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    // TODO: Allow for selection and pass back selection data.
}