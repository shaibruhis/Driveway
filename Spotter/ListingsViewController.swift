//
//  ListingsViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/12/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit

class ListingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToListingsViewController(segue:UIStoryboardSegue){
        // Do nothing as we transition back to here when user cancels the "add new listing"
    }
    
    @IBAction func postListing(segue:UIStoryboardSegue){
        // TODO: add code to add listing to database.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
