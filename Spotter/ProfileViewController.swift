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
        
        firstName.text = String("")
        lastName.text = String("")
        phoneNumber.text = String("")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            
            self.firstName.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["First Name"] as? String
            self.lastName.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["Last Name"] as? String
            self.phoneNumber.text = snapshot.childSnapshotForPath(self.ref.authData.uid).value["Phone Number"] as? String
            

//            if let first =  snapshot.childSnapshotForPath(self.ref.authData.uid).value["First Name"] as? String {
//                print("\(snapshot.key) was \(first) meters tall")
//            }

//            snapshot.childSnapshotForPath(self.ref.authData.uid).value["First Name"]
//            print(snapshot.childSnapshotForPath(self.ref.authData.uid))
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateButton(sender: AnyObject) {
        
        let userRef = self.ref.childByAppendingPath(self.ref.authData.uid)
        let newFirstName = ["First Name": self.firstName.text!]
        let newLastName = ["Last Name": self.lastName.text!]
        let newPhoneNumber = ["Phone Number": self.phoneNumber.text!]
        
        userRef.updateChildValues(newFirstName)
        userRef.updateChildValues(newLastName)
        userRef.updateChildValues(newPhoneNumber)
        
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
