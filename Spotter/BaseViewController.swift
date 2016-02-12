//
//  BaseViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/10/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    @IBOutlet var menuIconCollection: [UIBarButtonItem]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // is this the most efficient way? goes through each button each time this is called.
        // we only want to do it for button on screen
        for button in menuIconCollection {
            button.target = self.revealViewController()
            button.action = Selector("revealToggle:")
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
