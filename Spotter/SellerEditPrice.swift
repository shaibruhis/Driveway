//
//  SellerEditPrice.swift
//  Spotter
//
//  Created by Christopher Chan on 2/27/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import UIKit

class SellerEditPriceViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var userPriceInput: UITextField!
    @IBOutlet weak var savePriceButton: UIBarButtonItem!
    var decimalPointExists: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPriceInput.delegate = self
        userPriceInput.keyboardType = .DecimalPad
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let validInputSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(validInputSet)
        let validInputFiltered = compSepByCharInSet.joinWithSeparator("")
        
        if(!(textField.text!.characters.contains("."))){
            decimalPointExists = false
        }//Accounts for insertion and deletion (primarily deletion); updates whether or not there is a decimal
        else{
            var numsAfterDecimal = textField.text?.componentsSeparatedByString(".")
            if(numsAfterDecimal![1].characters.count < 2 && string != "."){
                return string == validInputFiltered
            }
            else{
                if(string == ""){
                    return true
                }//if we're deleting
                else{
                    return false
                }
            }
        }//if there is a decimal, check if entered character is valid and that there isn't more than 2 characters hafter the decimal

        
        if(string == "."){
            if(decimalPointExists == true){
                return false
            }
            else{
                decimalPointExists = true
            }
        }//Accounts for single character insertion. If decimal point doesn't exist, allow user to place decimal point. If it does, then don't.
        return string == validInputFiltered
    }
}//TODO: show a popup warning notifying that the user is trying to list spot for free (when they input 0., .0, and all other permutations of $0

