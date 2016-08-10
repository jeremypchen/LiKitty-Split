//
//  AddItemsViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/17/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let splitModel = SplitModel.sharedInstance
    var itemAndPrices: [(name: String, price: Double?)] = []
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemsTableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    
    var yLabelPos: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        itemTextField.becomeFirstResponder()
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        let existingItems = splitModel.getAllItems()
        
        for (itemName, item) in existingItems {
            itemAndPrices.append((itemName, item.itemPrice))
        }
        
        addButton.tag = 0
        
        itemsTableView.separatorInset = UIEdgeInsetsZero
    }
    
    override func viewDidAppear(animated: Bool) {
        yLabelPos = itemsTableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)).origin.y
    }
    
    @IBAction func addButtonPushed(sender: AnyObject) {
        let warningAlert = UIAlertController.init(
            title: "Error",
            message: "",
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
        warningAlert.addAction(OKAction)
        
        // Adding Item Name
        if addButton.tag == 0 {
            if let itemName = itemTextField.text where !itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
                if splitModel.itemNameAlreadyUsed(itemName) {
                    warningAlert.message = "Item already exists."
                    let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                    rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
                    
                } else {
                    handleNewItemName(itemName)
                }
            } else {
                warningAlert.message = "Item name cannot be empty."
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
            }
            
        // Adding Item Price
        } else {
            let itemPrice = itemTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "$"))
            
            if let price = Double(itemPrice!) {
                handleNewItemPrice(Double(String(format: "%.2f", price))!)
            } else {
                warningAlert.message = "Invalid or empty item price."
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
            }
        }
    }
    
    func handleNewItemName(itemName: String) {
        // add item to list of item names
        itemAndPrices.append((itemName, nil))
        
        // animate item name to position in table
//        let itemNameLabel = UILabel(frame: CGRectMake(itemTextField.frame.origin.x,
//            itemTextField.frame.origin.y,
//            itemTextField.frame.width,
//            itemTextField.frame.height))
//        
//        itemNameLabel.textAlignment = NSTextAlignment.Center
//        itemNameLabel.text = itemName
//        itemNameLabel.font = itemNameLabel.font.fontWithSize(20)
//        
//        self.view.addSubview(itemNameLabel)
//        
//        // animate to y_pos
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//            itemNameLabel.frame.origin.y = self.yLabelPos!
//            itemNameLabel.frame.origin.x = self.itemsTableView.frame.origin.x
//        })
        
        itemsTableView.reloadData()
//        itemNameLabel.hidden = true
        
        // change text of button to Add Item Price
        addButton.setTitle("Add item price", forState: UIControlState.Normal)
        
        // change state of button to 1
        addButton.tag = 1
        
        // clear textfield, add '$' to textfield
        itemTextField.text = "$"
        
        // change keyboard to number
        itemTextField.keyboardType = UIKeyboardType.DecimalPad
    }
    
    func handleNewItemPrice(itemPrice: Double) {
        // add price to tuple list
        itemAndPrices[itemAndPrices.count-1].price = itemPrice
        
        let itemName = itemAndPrices[itemAndPrices.count-1].name
        
        // add new Item with name and price into splitmodel
        splitModel.addItem(itemName, itemPrice: itemPrice, taxIncluded: false)
        
        // animate price name to position in table
        // animate item name to position in table
//        let priceLabel = UILabel(frame: CGRectMake(itemTextField.frame.origin.x,
//            itemTextField.frame.origin.y,
//            itemTextField.frame.width,
//            itemTextField.frame.height))
//        
//        priceLabel.textAlignment = NSTextAlignment.Center
//        priceLabel.text = String(itemPrice)
//        priceLabel.font = priceLabel.font.fontWithSize(20)
//        priceLabel.textColor = UIColor.orangeColor()
//        
//        self.view.addSubview(priceLabel)
//        
//        // animate to y_pos
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//            priceLabel.frame.origin.y = self.yLabelPos!
//            priceLabel.frame.origin.x = self.itemsTableView.frame.origin.x
//            
//            // increment y_pos
//            self.yLabelPos! += self.itemsTableView.rowHeight
//        })
        
        itemsTableView.reloadData()
        
        // change text of button to add item name
        addButton.setTitle("Add item name", forState: UIControlState.Normal)
        
        // change state of button to 0
        addButton.tag = 0
        
        // clear textfield
        itemTextField.text = ""
        
        // change keyboard to normal
        itemTextField.keyboardType = UIKeyboardType.Alphabet
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemAndPrices.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // always have subtotal as last cell
        if (indexPath.row == itemAndPrices.count)
        {
            let cellIdentifier = "SubtotalCell"
            
            var cell = itemsTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            
            cell!.detailTextLabel!.text = String(format:"$%.02f", splitModel.getSubtotal())
            
            return cell!
        } else {
            let cellIdentifier = "ItemCell"
            
            var cell = itemsTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            
            // firstdetail is from list of name/price tuples
            cell!.textLabel!.text = itemAndPrices[indexPath.row].name
            
            // second detail can be empty, from list of name/price tuples
            if let price = itemAndPrices[indexPath.row].price {
                cell!.detailTextLabel!.text = String(format:"$%.02f", price)
            } else {
                cell!.detailTextLabel!.text = ""
            }
            
            return cell!
        }
    }
    
    // should perform segue - don't perform segue to assign item if no items added yet
    
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let keyboardFrame = view.convertRect(value.CGRectValue, fromView: nil)
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
}
