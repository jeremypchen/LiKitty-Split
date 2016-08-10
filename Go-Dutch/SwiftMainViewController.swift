//
//  SwiftMainViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/30/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let splitModel = SplitModel.sharedInstance
    
    // Buttons
    @IBOutlet weak var taxTipButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    
    // Labels
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var taxRateLabel: UILabel!
    @IBOutlet weak var tipRateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    // Other Views
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        itemsTableView.dataSource = self
        itemsTableView.delegate = self
        itemsTableView.separatorInset = UIEdgeInsetsZero;

        self.itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        self.navigationController?.hidesBarsWhenKeyboardAppears = true

        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
//        case "":
//            let addItemVC = segue.destinationViewController
//            break
            
        default:
            print("Unknown segue: \(segue.identifier)")
        }
    }
    
    private func reloadData() {
        // Set updated tax and tip amounts in proper format: $12.50
        taxLabel.text = String(format: "$%.02f", splitModel.getTaxAmount())
        tipLabel.text = String(format: "$%.02f", splitModel.getTipAmount())
        
        // Set updated tax and tip rates in proper format: 8.0% and 15.0%
//        taxRateLabel.text = String(format: "%.01f%%", splitModel.getTaxRate()*100)
//        tipRateLabel.text = String(format: "%.01f%%", splitModel.getTipRate()*100)
        
        // Set updated total label in proper format: $12.50
        totalLabel.text = String(format: "$%.02f", splitModel.getTotal())
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitModel.getItemCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ItemCell"
        
        var cell = itemsTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        cell!.textLabel?.text = splitModel.getItemNameAtIndex(indexPath.row)
        
        print(String(format: "$%.02f", splitModel.getItemPriceAtIndex(indexPath.row)))
        
        cell!.detailTextLabel?.text = String(format: "$%.02f", splitModel.getItemPriceAtIndex(indexPath.row))

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}