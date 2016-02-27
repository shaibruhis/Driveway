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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPriceInput.delegate = self
        userPriceInput.keyboardType = .NumberPad
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(string)
        //TODO: constrain to only positive integers and 1 decimal point w max 2 ints after the decimal.
        return true
    }
    
}