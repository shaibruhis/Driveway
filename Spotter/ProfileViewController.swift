//
//  ProfileViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/12/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: BaseViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!


    let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            //Setting the text boxes to display their respective attributes (First, Last, and Phone Number
            self.firstName.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["First Name"] as? String
            self.lastName.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["Last Name"] as? String
            self.phoneNumber.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["Phone Number"] as? String
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func convertJSONToDictionary(snapshot: FDataSnapshot) -> [NSDictionary]? {

        var tempItems = [NSDictionary]()
        for item in snapshot.children {
            let child = item as! FDataSnapshot
            let dict = child.value as! NSDictionary
            tempItems.append(dict)
        }
        return tempItems
    }
    
    
    @IBAction func updateButton(sender: AnyObject) {
        
        //Letting the user type in the text box to update their name
        let userRef = self.ref.childByAppendingPath(self.ref.authData.uid)
        let locationRef = Firebase(url: "https://blinding-fire-154.firebaseio.com/Locations")
        let newFirstName = ["First Name": self.firstName.text!]
        let newLastName = ["Last Name": self.lastName.text!]
        let newPhoneNumber = ["Phone Number": self.phoneNumber.text!]
        
        //Update
        userRef.updateChildValues(newFirstName)
        userRef.updateChildValues(newLastName)
        userRef.updateChildValues(newPhoneNumber)
        
        
        var locationList = [NSDictionary]()

        
        locationRef.observeEventType(.Value, withBlock: { snapshot in
            
            locationList = self.convertJSONToDictionary(snapshot)!
            for location in locationList {
                if(self.ref.authData.uid == location["Owner"]! as! String){
                    locationRef.childByAppendingPath(location["SpotID"] as! String).updateChildValues(newFirstName)
                    locationRef.childByAppendingPath(location["SpotID"] as! String).updateChildValues(newPhoneNumber)
                }
            }
            
        })//snapshot

        
        
        //Display box to show the user that it updated
        let title = "Profile Updated"
        let message = "Success"
        let okText = "OK"
        let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
