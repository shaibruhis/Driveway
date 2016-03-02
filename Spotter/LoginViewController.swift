//
//  LoginViewController.swift
//  Spotter
//
//  Created by Senior Design on 3/1/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class LoginViewController : UIViewController{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a reference to a Firebase location
        
    }
    

    @IBAction func signupButton(sender: AnyObject) {
         self.performSegueWithIdentifier("Signup Segue", sender: nil)
        
    }


    @IBAction func loginButton(sender: AnyObject) {

        
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
                self.performSegueWithIdentifier("Login To Main Segue", sender: nil)
                
            }
            
        
        }
        
    }
    
    @IBAction func returnToLoginPage(Segue: UIStoryboardSegue){

    }

    
    
}


