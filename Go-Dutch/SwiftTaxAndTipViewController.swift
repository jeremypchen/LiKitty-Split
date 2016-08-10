//
//  SwiftTaxAndTipViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/2/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftTaxAndTipViewController: UIViewController, UITextFieldDelegate {
    
    let splitModel = SplitModel.sharedInstance
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var taxSegmentedControl: UISegmentedControl!
    @IBOutlet weak var taxCustomField: UITextField!
    
    @IBOutlet weak var tipRateLabel: UILabel!
    @IBOutlet weak var taxAmountField: UITextField!
    @IBOutlet weak var tipAmountField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    var newTaxRate: Double!
    var newTipRate: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        totalLabel.text = String(format: "%.02f", splitModel.getTotal())
        
//        tipSlider.value = (Float)(splitModel.getTipRate()*100)
//        tipRateLabel.text = String(format: "%.01f%%", splitModel.getTipRate()*100)
        
        //    self.tipRateLabel.frame = CGRectMake([self xPositionFromSliderValue: self.tipSlider], self.tipRateLabel.frame.origin.y, self.tipRateLabel.frame.size.width, self.tipRateLabel.frame.size.width);
        
        // Set global variables as current value in case Done is pushed and one or neither were updated
//        newTipRate = splitModel.getTipRate()
//        newTaxRate = splitModel.getTaxRate()
        
        // Set tax and tip amount label
        taxAmountField.text = String(format: "%.02f", splitModel.getTaxAmount())
        tipAmountField.text = String(format: "%.02f", splitModel.getTipAmount())
        taxCustomField.text = String(format: "%.01f", newTaxRate * 100)

        if (newTaxRate == 0.08) {
            taxSegmentedControl.selectedSegmentIndex = 0;
        } else if (newTaxRate == 0.09) {
            taxSegmentedControl.selectedSegmentIndex = 1;
        } else if (newTaxRate == 0.1) {
            taxSegmentedControl.selectedSegmentIndex = 2;
        } else {
            taxSegmentedControl.selectedSegmentIndex = 3;
            taxCustomField.hidden = false;
        }
    }
    
    @IBAction func taxSegmentedControlChanged(sender: AnyObject) {
        // Set new tax rate in global variable. This will be used in completion handler.
        taxCustomField.hidden = true

        switch taxSegmentedControl.selectedSegmentIndex {
        case 0:
            newTaxRate = 0.08
            break
        case 1:
            newTaxRate = 0.09
            break
        case 2:
            newTaxRate = 0.10
            break
        case 3:
            newTaxRate = Double(taxCustomField.text!)!/100
            taxCustomField.hidden = false
            break
        default:
            taxCustomField.hidden = true
        }
        
        taxAmountField.text = String(format: "%.02f", newTaxRate * splitModel.getSubtotalMinusItemsWithTaxIncluded()
        )
        
        reloadTotal()
    }
    
    @IBAction func tipSliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        
        let numberAsInt = (Int)(slider.value)
        
        // Update tip rate label
        tipRateLabel.text = String(format: "%.01d%%", numberAsInt)
        
        // Set new tip rate in global variable. This will be used in completion handler
        newTipRate = Double(numberAsInt)/100.0
        
        tipAmountField.text = String(format: "%.02f", newTipRate * splitModel.getSubtotal())
        
        reloadTotal()
    }
    
    @IBAction func taxCustomFieldChanged(sender: AnyObject) {
        newTaxRate = Double(taxCustomField.text!)!/100
        
        taxAmountField.text = String(format:"%.02f", newTaxRate * splitModel.getSubtotalMinusItemsWithTaxIncluded())
        
        reloadTotal()
    }
    
    @IBAction func taxAmountFieldChanged(sender: AnyObject) {
        newTaxRate = Double(taxAmountField.text!)!/splitModel.getSubtotalMinusItemsWithTaxIncluded()
        
        taxSegmentedControl.selectedSegmentIndex = 3
        taxCustomField.hidden = false
        taxCustomField.text = String(format:"%.01f", newTaxRate*100)
        
        reloadTotal()
    }
    
    @IBAction func tipAmountFieldChanged(sender: AnyObject) {
        newTipRate = Double(tipAmountField.text!)!/splitModel.getSubtotal()
        
        // Adjust position of slider
        tipRateLabel.text = String(format:"%.01f%%", newTipRate*100)
        tipSlider.setValue(Float(newTipRate*100), animated: true)
        
        reloadTotal()
    }
    
    @IBAction func backgroundButtonPushed(sender: AnyObject) {
        taxCustomField.resignFirstResponder()
        taxAmountField.resignFirstResponder()
        tipAmountField.resignFirstResponder()
    }
    
    func reloadTotal() {
        // Update the total label at the bottom of the UI based on new tax and tip rates
        let subtotal = splitModel.getSubtotal()
        let newTotal = subtotal + newTaxRate*subtotal + newTipRate*subtotal
        
        totalLabel.text = String(format:"%.02f", newTotal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case ("SaveTaxAndTipSuccess"):
//            splitModel.setTaxRate(newTaxRate)
//            splitModel.setTipRate(newTipRate)
            
            break
            
        default:
            print ("Unknown segue: \(segue)")
            break
        }
    }
}







