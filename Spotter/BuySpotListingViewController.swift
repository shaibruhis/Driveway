//
//  BuySpotListingViewController.swift
//  Spotter
//
//  Created by Christopher Chan on 4/13/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import Braintree


class BuySpotListingViewController : UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, BTDropInViewControllerDelegate{
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!

    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var lat : Double?
    var lon : Double?
    var address : String?
    var firstName : String?
    var price : String?
    var phoneNumber : String?
    var spotId : String?
    var startTime: String?
    var endTime: String?
    
    var braintreeClient: BTAPIClient?
    var BTnavigationController: UINavigationController?

    let timeFormatter = NSDateFormatter()
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return UIBarPosition.TopAttached
    }
    
    @IBAction func bookButton(sender: AnyObject) {
        
        
        let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/Locations")
        let spotRef = ref.childByAppendingPath(spotId)

        if(checkForValidTime()){
            spotRef.updateChildValues(["Is Available": "False", "Rented Until": timeFormatter.stringFromDate(timePicker.date)]) { (error, firebase) in
                self.presentViewController(self.BTnavigationController!, animated: true, completion: nil)
            }
        }
        else {
            //Display box to show the user that it has a booked an invalid time
            let title = "Invalid Time"
            let message = "Booking time is out of available time range."
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func checkForValidTime() -> Bool{
        let calendar = NSCalendar.currentCalendar()

        let timePickerComponents = calendar.components([.Hour, .Minute], fromDate: timePicker.date)
        let timePickerHour = timePickerComponents.hour
        let timePickerMinute = timePickerHour * 60 + timePickerComponents.minute
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let startDate = dateFormatter.dateFromString(startTime!)
        let endDate = dateFormatter.dateFromString(endTime!)
        
        let startTimeComponents = calendar.components([.Hour, .Minute], fromDate: startDate!)
        let endTimeComponents = calendar.components([.Hour, .Minute], fromDate: endDate!)
        
        let startMinute = startTimeComponents.minute + startTimeComponents.hour * 60
        let endMinute = endTimeComponents.minute + endTimeComponents.hour * 60
        
        if(startMinute == endMinute){
            return true
        }
        else if(startMinute < endMinute){
            if(timePickerMinute >= startMinute && timePickerMinute < endMinute){
                return true;
            }
            else{
                return false;
            }
        } //spot listing doesn't go past a day
        else{
            if(timePickerMinute > startMinute && timePickerMinute > endMinute){
                return true
            }
            else if(timePickerMinute < startMinute && timePickerMinute < endMinute){
                return true
            }
            else{
                return false
            }
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter.timeStyle = .ShortStyle
        navBar.delegate = self
        
        timePicker.datePickerMode = UIDatePickerMode.Time
        
        firstNameLabel.text = firstName
        addressLabel.text = address
        priceLabel.text = "$\(price!)"
        
        let startIndex = phoneNumber!.startIndex.advancedBy(3)
        let endIndex = phoneNumber!.endIndex.advancedBy(-4)
        let areacode = phoneNumber!.substringToIndex(startIndex)
        let firstThree = phoneNumber!.substringWithRange(startIndex..<endIndex)
        let secondFour = phoneNumber!.substringFromIndex(endIndex)
        phoneLabel.text = "(\(areacode)) \(firstThree)-\(secondFour)"
        
        availableLabel.text = "Available: \(startTime) - \(endTime)"term
        
//        timePicker.addTarget(self, action: Selector("timeChange:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let clientTokenURL = NSURL(string: "http://52.34.47.19/client_token")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        
        // TODO: If server is down brain tree client will not initalize because tokens did not come through
        // add error handler to present UI with view
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            let clientToken = String(data: data, encoding: NSUTF8StringEncoding)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            
            // If you haven't already, create and retain a `BTAPIClient` instance with a
            // tokenization key OR a client token from your server.
            // Typically, you only need to do this once per session.
            // braintreeClient = BTAPIClient(authorization: aClientToken)
            
            // Create a BTDropInViewController
            let dropInViewController = BTDropInViewController(APIClient: self.braintreeClient!)
            dropInViewController.delegate = self
            
            // This is where you might want to customize your view controller (see below)
            
            // The way you present your BTDropInViewController instance is up to you.
            // In this example, we wrap it in a new, modally-presented navigation controller:
            dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self, action: #selector(self.userDidCancelPayment))
        
            
            self.BTnavigationController = UINavigationController(rootViewController: dropInViewController)
            
            // As an example, you may wish to present our Drop-in UI at this point.
        }.resume()
    }
    
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        
    }
    
    func userDidCancelPayment () {
        dismissViewControllerAnimated(true, completion: nil)
    }
}