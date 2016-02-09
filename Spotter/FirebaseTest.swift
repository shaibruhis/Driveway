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
        }
    

}


