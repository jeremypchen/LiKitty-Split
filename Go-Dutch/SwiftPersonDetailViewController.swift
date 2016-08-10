//
//  SwiftPersonDetailViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/2/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftPersonDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var itemDetailTableView: UITableView!
    
    let splitModel = SplitModel.sharedInstance
    
    var currentPerson: Person?
    var personName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle.title = personName!
        
        currentPerson = splitModel.returnPersonByName(personName!)
        taxAmountLabel.text = String(format:"$%.02f", currentPerson!.getTaxContribution())
        
        taxAmountLabel.text = String(format:"$%.02f", currentPerson!.getTipContribution())
        
        taxAmountLabel.text = String(format:"$%.02f", currentPerson!.getTotalContribution())
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPerson!.getAllItems().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let DetailCellIdentifier = "DetailCell"
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(DetailCellIdentifier) {
            let items = currentPerson!.getAllItemsWithPriceAndPercentages()
            let index = indexPath.row
            let keys = Array(items.keys)
            var label = cell.viewWithTag(1) as! UILabel
            
            let keyAtIndex = keys[index]
            label.text = keyAtIndex
            
            let itemDict = items[keyAtIndex]!
            let itemPrice = itemDict["Price"]!
            let itemWeight = itemDict["Percentage"]!
            
            label = cell.viewWithTag(2) as! UILabel
            label.text = String(format:"%d%%", Int(Double(itemWeight)*100))
            
            let finalPrice = Double(itemPrice) * Double(itemWeight)
            
            label = cell.viewWithTag(3) as! UILabel
            label.text = String(format: "$%.02f", finalPrice)
            
            return cell
        } else {
            let cellObjects = NSBundle.mainBundle().loadNibNamed("DetailCell", owner: self, options: nil)
            return cellObjects[0] as! UITableViewCell
        }
    }
}
