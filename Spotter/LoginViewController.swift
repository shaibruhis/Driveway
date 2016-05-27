//
//  LoginViewController.swift
//  Spotter
//
//  Created by Senior Design on 3/1/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class LoginViewController : UIViewController, UITextFieldDelegate{

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
    }
    

    @IBAction func signupButton(sender: AnyObject) {
         self.performSegueWithIdentifier("Signup Segue", sender: nil)
        
    }

    func login() {
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
                ref.childByAppendingPath("Users")
                    .childByAppendingPath(authData.uid)
                    .observeEventType(.Value, withBlock: { snapshot in
                        print(snapshot.value)
                    })
                self.performSegueWithIdentifier("Login To Main Segue", sender: nil)
            }
        }
    }

    @IBAction func loginButton(sender: AnyObject) {
        login()
    }
    
    @IBAction func returnToLoginPage(Segue: UIStoryboardSegue){

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == password {
            textField.returnKeyType = .Go
        }
        else if textField == username {
            textField.returnKeyType = .Next
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.username {
            self.password.becomeFirstResponder()
        }
        else if textField == self.password {
            textField.resignFirstResponder()
            login()
        }
        return true
    }
    
    
}


