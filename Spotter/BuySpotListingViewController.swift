//
//  BuySpotListingViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 4/13/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase


class BuySpotListingViewController : UIViewController{
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!

    
    
    var lat : Double?
    var lon : Double?
    var address : String?
    var firstName : String?
    var price : String?
    var phoneNumber : String?
    

    @IBAction func bookButton(sender: AnyObject) {
        
        print(timeLabel.text!)
    }
    func timeChange(sender: UIDatePicker) {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        timeLabel.text = formatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
        
        timePicker.datePickerMode = UIDatePickerMode.Time
        
        firstNameLabel.text = firstName
        addressLabel.text = address
        priceLabel.text = price
        phoneLabel.text = phoneNumber
        
        timePicker.addTarget(self, action: Selector("timeChange:"), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    
}