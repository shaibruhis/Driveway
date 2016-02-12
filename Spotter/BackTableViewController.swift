//
//  BackTableViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 2/6/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation

class BackTableViewController: UITableViewController {
    var menuArray = [String]()
    
    override func viewDidLoad() {
        menuArray = ["Profile", "Home", "Reservations", "Selling", "Payment", "History", "Settings"]
    }
    
    override func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segueIdentifier = "\(menuArray[indexPath.row]) Segue"
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
}