//
//  FirebaseTest.swift
//  Spotter
//
//  Created by Senior Design on 2/8/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseTest : BaseViewController {
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a reference to a Firebase location
        
    }
    
    @IBAction func submit(sender: UIButton) {
        

        let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
        // Link to Firebase
 
        ref.authUser(username.text, password: password.text) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
                let title = "Error"
                let message = "Incorrect Username/Password"
                let okText = "OK"
                let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
                let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(okayButton)
                self.presentViewController(alert, animated: true, completion: nil)
                //Display the Okay button
                
            } else {
                // user is logged in, check authData for data
                let title = "Logged In"
                let message = "Successfully logged into Firebase"
                let okText = "OK"
                let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
                let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(okayButton)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        
    }

    

}


