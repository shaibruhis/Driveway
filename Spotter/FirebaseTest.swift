//
//  FirebaseTest.swift
//  Spotter
//
//  Created by Senior Design on 2/8/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseTest : UIViewController {
    override func viewDidLoad() {
        
        
        
        
        
        
        // Create a reference to a Firebase location
        var ref = Firebase(url: "https://blinding-fire-154.firebaseio.com/")
        // Write data to Firebase
        ref.setValue("Do you have data? You'll love Firebase.")
        
        ref.createUser("test@example.com", password: "12345",
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


