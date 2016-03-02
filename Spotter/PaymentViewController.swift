//
//  PaymentViewController.swift
//  Spotter
//
//  Created by Shai Bruhis on 2/12/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import UIKit
import Braintree

class PaymentViewController: BaseViewController, BTDropInViewControllerDelegate {

    var braintreeClient: BTAPIClient?
    var BTnavigationController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clientTokenURL = NSURL(string: "http://52.34.47.19/client_token")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        
        // TODO: If server is down brain tree client will not initalize because tokens did not come through
        // add error handler to present UI with view 
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { (data, response, error) -> Void in
//             TODO: Handle errors
            guard let data = data else {
                return
            }
            let clientToken = String(data: data, encoding: NSUTF8StringEncoding)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            
            // If you haven't already, create and retain a `BTAPIClient` instance with a
            // tokenization key OR a client token from your server.
            // Typically, you only need to do this once per session.
            // braintreeClient = BTAPIClient(authorization: aClientToken)
            
            // Create a BTDropInViewController
            let dropInViewController = BTDropInViewController(APIClient: self.braintreeClient!)
            dropInViewController.delegate = self
            
            // This is where you might want to customize your view controller (see below)
            
            // The way you present your BTDropInViewController instance is up to you.
            // In this example, we wrap it in a new, modally-presented navigation controller:
            dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                target: self, action: "userDidCancelPayment")
            
            
            self.BTnavigationController = UINavigationController(rootViewController: dropInViewController)
            self.presentViewController(self.BTnavigationController!, animated: true, completion: nil)
            
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
        }.resume()

        // Do any additional setup after loading the view.
    }
    
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {

    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {

    }
    
    func userDidCancelPayment () {
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
