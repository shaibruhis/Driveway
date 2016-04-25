//
//  Listing.swift
//  Spotter
//
//  Created by Shai Bruhis on 4/13/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation

class Listing {
    var listingID: String
    var lat: String
    var lon: String
    var address: String
    
    init(listingID: String, lat: String, lon: String, address: String)
    {
        self.listingID = listingID
        self.lat = lat
        self.lon = lon
        self.address = address
    }
    
    convenience init()
    {
        self.init(listingID: "", lat: "", lon: "", address: "")
    }
}