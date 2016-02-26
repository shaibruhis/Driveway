//
//  SearchResultsController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/23/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit

// have to use @objc because only objc protocols allow for options functions
@objc protocol LocateOnTheMap{
    optional func locateWithLongitude(lon:Double, andLatitude lat:Double, andTitle title: String)
    optional func modelView(finishedWithValue: String)
}


class SearchResultsController: UITableViewController {

    var searchResults: [String]!
    var delegate: LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchResults = Array()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }



    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        // dismiss table view controller with autocompleted results
        delegate.modelView!(searchResults[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
        // construct url for api request
//        let correctedAddress:String! = self.searchResults[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet())
//        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)")
//
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
//            // 3
//            do {
//                if data != nil {
//                    let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as!  NSDictionary
//                    
//                    let lat = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat")?.objectAtIndex(0) as! Double
//                    let lon = dic["results"]?.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng")?.objectAtIndex(0) as! Double
//                    // 4
////                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row] )
//                    print("lat = \(lat), lon = \(lon)")
//                }
//            } catch {
//                print("Error")
//            }
//        }
//        // 5
//        task.resume()
    }
    
    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
}
