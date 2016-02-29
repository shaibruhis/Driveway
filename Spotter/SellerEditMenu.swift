//
//  SellerEditMenu.swift
//  Spotter
//
//  Created by Christopher Chan on 2/15/16.
//  Copyright © 2016 Christopher Chan. All rights reserved.
//

import Foundation
import Firebase

class SellerEditMenu: UIViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITableViewDelegate{
    var menuArray = [String]()
    @IBOutlet var saveListingButton: UIBarButtonItem!
    @IBOutlet weak var cancelListingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
//        menuArray = ["Parking Type", "Address", "Parking Dimensions", "Price", "Availability"]
        menuArray = ["Address", "Price"]

    }
    
    func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sellerListingEditCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = menuArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let segueIdentifier = "Seller \(menuArray[indexPath.row]) Segue"
        performSegueWithIdentifier(segueIdentifier, sender: nil)
    }
    
    func checkForCompletion(){
        if(SellerEditMenuSingleton.sharedInstance.checkAddressCompletion()){
            // place check mark on the right within the address cell
        }
        if(SellerEditMenuSingleton.sharedInstance.checkPriceCompletion()){
            // place check mark on the right of the price cell
        }
    }
    
    @IBAction func returnToSellerEditMenu(Segue: UIStoryboardSegue){
        //call checkforcompletion here
        if(SellerEditMenuSingleton.sharedInstance.checkAllCompletion()){
            saveListingButton.enabled = true
        }
        else{
            saveListingButton.enabled = false
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === cancelListingButton{
            SellerEditMenuSingleton.sharedInstance.resetValues()
        }
        if sender === saveListingButton{
            SellerEditMenuSingleton.sharedInstance.resetValues()
        }//need to also post to database
    }

    /////////Camera
    
    @IBOutlet weak var uploadPhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        imageView.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(uploadPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    

    @IBAction func buttonClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(uploadPhoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
}
//TODO: Make sellereditmenu contain a container view which houses a tableviewcontroller in order to use static cell. Use delegation when cell is selected to change parentView via segue.