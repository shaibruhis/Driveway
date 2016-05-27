//
//  SignUpViewController.Swift
//  Spotter
//
//  Created by Senior Design on 2/16/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase


class SignUpViewController : UIViewController, UINavigationBarDelegate, UIBarPositioningDelegate, UITextFieldDelegate{
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    @IBOutlet weak var navBar: UINavigationBar!
    
    let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        emailAddress.delegate = self
        password.delegate = self
        phoneNumber.delegate = self

    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return UIBarPosition.TopAttached
    }
    
    func createAccount() {
        if( firstName.text == "" || lastName.text == "" || phoneNumber.text == "" || emailAddress.text == "" || password.text == ""){
            let title = "Error"
            let message = "Missing Information"
            let okText = "OK"
            let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okayButton)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else{
            ref.createUser(emailAddress.text, password: password.text,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                print(error)
                                // There was an error creating the account
                            }
                            else {
                                self.ref.authUser(self.emailAddress.text, password: self.password.text, withCompletionBlock: {error, authData in
                                    if error != nil{
                                        //catch error
                                    }
                                    else{
                                        let newUser = ["First Name": self.firstName.text!, "Last Name": self.lastName.text!, "Phone Number": self.phoneNumber.text!, "Email": self.emailAddress.text!]
                                        self.ref.childByAppendingPath("Users")
                                            .childByAppendingPath(authData.uid).setValue(newUser)
                                        self.performSegueWithIdentifier("Save and Back to Login Segue", sender: nil)
                                    }
                                    
                                })
                            }
            })//create user
            
        }//else
    }//done button

    @IBAction func doneButton(sender: AnyObject) {
        createAccount()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == firstName || textField == lastName || textField == emailAddress || textField == password || textField == phoneNumber {
            textField.returnKeyType = .Next
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.firstName {
            self.lastName.becomeFirstResponder()
        }
        else if textField == self.lastName {
            self.emailAddress.becomeFirstResponder()
        }
        else if textField == self.emailAddress {
            self.password.becomeFirstResponder()
        }
        else if textField == self.password {
            self.phoneNumber.becomeFirstResponder()
        }
        return true
    }

    
        
}

