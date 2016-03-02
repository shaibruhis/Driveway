//
//  SignUpViewController.Swift
//  Spotter
//
//  Created by Senior Design on 2/16/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase


class SignUpViewController : UIViewController{
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    
    
    
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
    
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
            
        let ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
        let newUser = ["First Name": firstName.text!, "Last Name": lastName.text!, "Phone Number": phoneNumber.text!, "Email": emailAddress.text!]
        //Get the data from the Text Box and putting them into Firebase
        let usersRef = ref.childByAppendingPath("Users")
        //Make the branch "Users" in the database
        let newUsersRef = usersRef.childByAutoId()
        //Auto-Generate a User ID
        newUsersRef.setValue(newUser)
        //write the values to the database
        
        ref.createUser(emailAddress.text, password: password.text,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")
                }
        })
            }
    }
    
}

