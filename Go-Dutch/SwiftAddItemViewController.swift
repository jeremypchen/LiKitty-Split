//
//  SwiftAddItemViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/2/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftAddItemViewController: UIViewController, UITextFieldDelegate {
    // Item and price text fields
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var taxExemptSwitch: UISwitch!
    @IBOutlet weak var dollarSignLabel: UILabel!
    
    // Model
    let splitModel = SplitModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        itemNameTextField.delegate = self
        itemPriceTextField.delegate = self
        itemNameTextField.becomeFirstResponder()
    }

    @IBAction func backgroundButtonPushed(sender: AnyObject) {
        itemNameTextField.resignFirstResponder()
        itemPriceTextField.resignFirstResponder()
    }
    
    @IBAction func priceTextFieldEdited(sender: AnyObject) {
        dollarSignLabel.textColor = UIColor.cyanColor()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let warningAlert = UIAlertController.init(
            title: "Error",
            message: "",
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
        warningAlert.addAction(OKAction)
        
        if (identifier == "AddItemSuccess") {
            if itemNameTextField.text == "" {
                warningAlert.message = "Please provide the name of the item."
                self.presentViewController(warningAlert, animated: true, completion: nil)
                
                return false
            }
            else if itemPriceTextField.text == "" {
                warningAlert.message = "Please provide the price of the item."
                self.presentViewController(warningAlert, animated: true, completion: nil)
                
                return false
            } else if splitModel.itemNameAlreadyUsed(itemNameTextField.text!) {
                warningAlert.message = "Item name already used, please use unique names."
                self.presentViewController(warningAlert, animated: true, completion: nil)
                
                return false
            }
        }
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField==itemNameTextField) {
            itemPriceTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case ("AddItemSuccess"):
                let addPeopleVC = segue.destinationViewController as! SwiftAddPeopleViewController
            
                let newItem = Item.init(itemName: itemNameTextField.text!, itemPrice: Double(itemPriceTextField.text!)!, taxIncluded: taxExemptSwitch.on)
            
                addPeopleVC.item = newItem
                break
            
            default:
                print ("Unknown destination VC for segue \(segue)")
            break
        }
    }

    
}