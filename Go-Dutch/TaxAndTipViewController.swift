//
//  TaxAndTipViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/22/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class TaxAndTipViewController: UIViewController {
    let splitModel = SplitModel.sharedInstance

    @IBOutlet weak var taxTitleLabel: UILabel!
    @IBOutlet weak var tipTitleLabel: UILabel!
    
    @IBOutlet weak var taxAmountButton: UIButton!
    @IBOutlet weak var tipAmountButton: UIButton!
    
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var taxtipTextField: UITextField!
    @IBOutlet weak var addTaxTipButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
        selector: #selector(keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        addTaxTipButton.tag = 0
        totalAmountLabel.text = String(format: "$%.2f", splitModel.getTotal())
        
        let taxAmount = splitModel.getTaxAmount()
        if taxAmount > 0 {
            taxAmountButton.hidden = false
            taxAmountButton.setTitle(String(format: "$%.2f", taxAmount), forState: UIControlState.Normal)
        }
        
        let tipAmount = splitModel.getTipAmount()
        if tipAmount > 0 {
            tipAmountButton.hidden = false
            tipAmountButton.setTitle(String(format: "$%.2f", tipAmount), forState: UIControlState.Normal)
        }
    
        taxtipTextField.becomeFirstResponder()
    }
    
    @IBAction func taxAmountButtonPushed(sender: AnyObject) {
        taxtipTextField.hidden = false
        
        taxAmountButton.hidden = true
        
        taxtipTextField.text = String(format: "$%.2f", splitModel.getTaxAmount())

        addTaxTipButton.tag = 0
        addTaxTipButton.setTitle("Add tax amount", forState: UIControlState.Normal)
    }
    
    @IBAction func tipAmountButtonPushed(sender: AnyObject) {
        taxtipTextField.hidden = false
        
        tipAmountButton.hidden = true
        
        taxtipTextField.text = String(format: "$%.2f", splitModel.getTipAmount())

        addTaxTipButton.tag = 1
        addTaxTipButton.setTitle("Add tip amount", forState: UIControlState.Normal)
    }
    
    @IBAction func addTaxTipButtonPushed(sender: AnyObject) {
        let warningAlert = UIAlertController.init(
            title: "Error",
            message: "",
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
        warningAlert.addAction(OKAction)
        
        if (addTaxTipButton.tag == 0) {
            // check that is valid and nonempty
            let taxAmount = taxtipTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
            
            if let taxAmountAsDouble = Double(taxAmount!) {
                splitModel.setTaxAmount(taxAmountAsDouble)

                handleTaxChangeUI(String(format: "$%.2f", taxAmountAsDouble))
                
                addTaxTipButton.tag = 1
            } else {
                warningAlert.message = "Invalid or empty tax amount."
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
            }
            
        } else if (addTaxTipButton.tag == 1) {
            let tipAmount = taxtipTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
            
            if let tipAmountAsDouble = Double(tipAmount!) {
                splitModel.setTipAmount(tipAmountAsDouble)
                
                handleTipChangeUI(String(format: "$%.2f", tipAmountAsDouble))
                
                addTaxTipButton.tag = 2
            } else {
                warningAlert.message = "Invalid or empty tax amount."
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
            }
        } else if (addTaxTipButton.tag == 2) {
            let splitVC = self.storyboard?.instantiateViewControllerWithIdentifier("FinalSplitViewController") as! SwiftFinalSplitViewController
            self.presentViewController(splitVC, animated: true, completion: nil)
        }
    }
    
    func handleTaxChangeUI(taxAmount: String) {
        addTaxTipButton.setTitle("Add tip amount", forState: UIControlState.Normal)
        
        taxAmountButton.setTitle(taxAmount, forState: UIControlState.Normal)
        
        let xTemp = taxAmountButton.frame.origin.x
        let yTemp = taxAmountButton.frame.origin.y
        
        taxAmountButton.frame.origin.x = taxtipTextField.frame.origin.x
        taxAmountButton.frame.origin.y = taxtipTextField.frame.origin.y
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.taxAmountButton.frame.origin.y = xTemp
            self.taxAmountButton.frame.origin.x = yTemp
        })
        
        taxAmountButton.hidden = false
        
        taxtipTextField.text = "$"
        
        totalAmountLabel.text = String(format: "$%.2f", splitModel.getTotal())
    }
    
    func handleTipChangeUI(tipAmount: String) {
        addTaxTipButton.setTitle("Go Dutch!", forState: UIControlState.Normal)
        
        tipAmountButton.setTitle(tipAmount, forState: UIControlState.Normal)
        
        let xTemp = tipAmountButton.frame.origin.x
        let yTemp = tipAmountButton.frame.origin.y
        
        tipAmountButton.frame.origin.x = taxtipTextField.frame.origin.x
        tipAmountButton.frame.origin.y = taxtipTextField.frame.origin.y
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.tipAmountButton.frame.origin.y = xTemp
            self.tipAmountButton.frame.origin.x = yTemp
        })
        
        tipAmountButton.hidden = false
        
        taxtipTextField.hidden = true
        
        totalAmountLabel.text = String(format: "$%.2f", splitModel.getTotal())
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let keyboardFrame = view.convertRect(value.CGRectValue, fromView: nil)
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
}
