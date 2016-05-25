//
//  BuySpotListingViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 4/13/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase


class BuySpotListingViewController : UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate{
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!

    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var lat : Double?
    var lon : Double?
    var address : String?
    var firstName : String?
    var price : String?
    var phoneNumber : String?
    var spotId : String?
    

    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return UIBarPosition.TopAttached
    }
    
    @IBAction func bookButton(sender: AnyObject) {
        
        let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/Locations")
        let spotRef = ref.childByAppendingPath(spotId)
        // wait for update in database before showing map again
        spotRef.updateChildValues(["Is Available": "False"]) { (error, firebase) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
  
        
       // print(timeLabel.text!)
    }
    func timeChange(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        timeLabel.text = formatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
        
        timePicker.datePickerMode = UIDatePickerMode.Time
        
        firstNameLabel.text = firstName
        addressLabel.text = address
        priceLabel.text = "$\(price!)"
        
        let startIndex = phoneNumber!.startIndex.advancedBy(3)
        let endIndex = phoneNumber!.endIndex.advancedBy(-4)
        let areacode = phoneNumber!.substringToIndex(startIndex)
        let firstThree = phoneNumber!.substringWithRange(startIndex...endIndex)
        let secondFour = phoneNumber!.substringFromIndex(endIndex)
        phoneLabel.text = "(\(areacode)) \(firstThree)-\(secondFour)"
        
        timePicker.addTarget(self, action: Selector("timeChange:"), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    
}