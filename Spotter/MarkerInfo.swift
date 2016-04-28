//
//  MarkerInfo.swift
//  Spotter
//
//  Created by Christopher Chan on 4/20/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//


import Foundation
import GoogleMaps

class MarkerInfo {

    var ownerFirstName : String = "null"
    var lat : Double?
    var lon : Double?
    var price : String = "null"
    var phone : String = "null"
    var address : String = "null"
    var spotId : String = "null"
    
    
    init(inputAddress: String, inputFirstName: String, inputLat: Double, inputLon: Double, inputPrice: String, inputPhone: String, inputSpotId : String){
        
        ownerFirstName = inputFirstName
        address = inputAddress
        lat = inputLat
        lon = inputLon
        price = inputPrice
        phone = inputPhone
        spotId = inputSpotId
    }
    
    
} //custom objects for marker userdata