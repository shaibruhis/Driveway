//
//  SellerEditMenuSingleton.swift
//  Spotter
//
//  Created by Christopher Chan on 2/25/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import GoogleMaps


class SellerEditMenuSingleton{
    static let sharedInstance = SellerEditMenuSingleton()
    private init(){} //Prevents this class from being initialized as it is a singleton
    
    var parkingCoordinates: CLLocationCoordinate2D?
    var price: Float?
    
    func resetValues(){
        price = nil
        parkingCoordinates = nil
    }
}
