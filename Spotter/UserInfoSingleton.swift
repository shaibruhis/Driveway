//
//  UserInfoSingleton.swift
//  Spotter
//
//  Created by Christopher Chan on 3/3/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class UserInfoSingleton{
    static let sharedInstance = UserInfoSingleton()
    private init(){}
    
    var ref: Firebase?

    func resetFirebaseRef(){
    
    }//need to reset current ref(?) when user logs out
    
}