//
//  SellerEditAvailableTimesViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 4/25/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit

class SellerEditAvailableTimesViewController: UIViewController {

    @IBOutlet weak var saveTimesButton: UIBarButtonItem!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    let timeFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter.timeStyle = .ShortStyle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveTimesButton === sender{
//            SellerEditMenuSingleton.sharedInstance.startTime = NSString(format: "%.2f", NSString(string: userPriceInput.text!).floatValue) as String
//            print(SellerEditMenuSingleton.sharedInstance.startTime)
//            SellerEditMenuSingleton.sharedInstance.endTime = NSString(format: "%.2f", NSString(string: userPriceInput.text!).floatValue) as String
//            print(SellerEditMenuSingleton.sharedInstance.startTime)
        }// converting input to valid float, might need to change it to currency instead if this app launches outside of US
    }

    @IBAction func timePickerChanged(sender: UIDatePicker) {
        print(timeFormatter.stringFromDate(startTimePicker.date))
        print(timeFormatter.stringFromDate(endTimePicker.date))
    }
 

}
