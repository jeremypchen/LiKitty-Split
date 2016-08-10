//
//  SwiftItemsTableViewController
//  LiKitty
//
//  Created by Jeremy Chen on 3/31/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftItemsTableViewController: UITableViewController {
    let splitModel = SplitModel.sharedInstance
    
    override func viewDidLoad() {
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitModel.getItemCount()
    }
    
    // TODO: Fill in these methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = splitModel.getItemNameAtIndex(indexPath.row)
//        [cell.textLabel setFont:[UIFont fontWithName:@"Noteworthy" size:20.0]];
        
//        let itemPriceString = String(withFormat: "$.02f", splitModel.getItemPrice)
//        
//        cell.detailTextLabel!.text = itemPriceString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
 
}