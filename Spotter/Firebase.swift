//
//  Firebase.swift
//  Spotter
//
//  Created by Senior Design on 2/8/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class Firebase : UIViewController {
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    // Create a reference to a Firebase location
    var myRootRef = Firebase(url:"https://blinding-fire-154.firebaseio.com")
    // Write data to Firebase
    myRootRef.setValue("Do you have data? You'll love Firebase.")
    
    myRootRef.observeEventType(.Value, withBlock: {
    snapshot in
    println("\(snapshot.key) -> \(snapshot.value)")
    })
}


