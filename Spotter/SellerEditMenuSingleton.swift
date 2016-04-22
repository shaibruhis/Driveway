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
    var address: String?
    var price: String?
    
    func resetValues(){
        address = nil
        price = nil
        parkingCoordinates = nil
    }
    
    

    func checkAddressCompletion() -> Bool{
        if let nonNilCoordinates = parkingCoordinates{
            if(CLLocationCoordinate2DIsValid(nonNilCoordinates)){
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }//else we have empty/nil coordinates, meaning the seller hasn't chosen an address to place their spot.
    
    func checkPriceCompletion() -> Bool{
        if(price?.isEmpty == nil){
            return false
        }
        return true
    }
    
    func checkAllCompletion() -> Bool{
        if(checkAddressCompletion() && checkPriceCompletion()){
            return true
        }
        else{
            return false
        }
    }
        
}
