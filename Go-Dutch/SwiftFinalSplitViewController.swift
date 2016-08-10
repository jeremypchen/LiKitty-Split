//
//  SwiftFinalSplitViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/2/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftFinalSplitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let splitModel = SplitModel.sharedInstance
//    let venmoInstance = Venmo.sharedInstance()
    
    @IBOutlet weak var finalSplitTableView: UITableView!
    
    var shouldSegue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        finalSplitTableView.delegate = self
        finalSplitTableView.dataSource = self
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "Venmo":
//            let venmoVC = segue.destinationViewController
            
            // venmoVC.backHandler
            
            break
        default:
            print("Unknown segue: \(segue.identifier)")
        }
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if (identifier == "VenmoSegue") {
//            if (!venmoInstance.isSessionValid() ||
//                !NSUserDefaults.standardUserDefaults().boolForKey("hasVenmoPermissions")) {
//                
//                // If user doesn't have Venmo
//                if (!Venmo.isVenmoAppInstalled()) {
//                    venmoInstance.requestPermissions(
//                        [VENPermissionMakePayments, VENPermissionAccessProfile,VENPermissionAccessFriends]) {
//                        success, error in
//                                if (success) {
//                                    print("Permission granted")
//                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasVenmoPermissions")
//                                } else {
//                                    print("Permission denied")
//                                    
//                                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasVenmoPermissions")
//                                }
//                    }
//                } else {
//                    let alert = UIAlertController(title: "Hold up!", message: "May freeze if you ask for passcode", preferredStyle: UIAlertControllerStyle.Alert)
//                    
//                    let venmoRunning = UIAlertAction(title: "We're good, Venmo is running!", style: UIAlertActionStyle.Default) {
//                        _ in
//                            alert.dismissViewControllerAnimated(true, completion: nil)
//                        // Request permissions when we hit this VC
//                        self.venmoInstance.requestPermissions([VENPermissionMakePayments, VENPermissionAccessProfile, VENPermissionAccessFriends]) {
//                            success, error in
//                            if (success) {
//                                print("Permission granted")
//                                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasVenmoPermissions")
//                            } else {
//                                print ("Permission denied")
//                                
//                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasVenmoPermissions")
//                            }
//                        }
//                    }
//                    
//                    let venmoNotRunning = UIAlertAction(title: "OK, open Venmo for me.", style: UIAlertActionStyle.Default) {
//                        _ in
//                        UIApplication.sharedApplication().openURL(NSURL(string: "venmo://")!)
//                        alert.dismissViewControllerAnimated(true, completion: nil)
//                    }
//                    
//                    let venmoCancel = UIAlertAction(title: "Never mind.", style: UIAlertActionStyle.Default) {
//                        _ in
//                        alert.dismissViewControllerAnimated(true, completion: nil)
//                    }
//                    
//                    alert.addAction(venmoRunning)
//                    alert.addAction(venmoNotRunning)
//                    alert.addAction(venmoCancel)
//                    
//                    presentViewController(alert, animated: true, completion: nil)
//                    
//                    return false
//                }
//            } else {
//                return true
//            }
//        }
//        return true
//    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != splitModel.returnAllPeople().count) {
            // get name based on index path
            let people = splitModel.returnAllPeople()
            let index = indexPath.row
            
            let personDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("PersonDetailViewController") as! SwiftPersonDetailViewController

            personDetailVC.personName = people[index].getName()

            self.presentViewController(personDetailVC, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitModel.returnAllPeople().count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == splitModel.returnAllPeople().count)
        {
            let cellIdentifier = "FinalSplitTotalCell"
            
            var cell = finalSplitTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            
            cell!.detailTextLabel!.text = String(format:"$%.02f", splitModel.getTotal())
            
            return cell!
            
        } else {
            let cellIdentifier = "FinalSplitPersonCell"
            
            var cell = finalSplitTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell?
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            
            // Get all people in model
            let people = splitModel.returnAllPeople()
            let index = indexPath.row
            
            // Set main text label as person's name
            cell!.textLabel!.text = people[index].getName()
            // set font
            
            // Set detail text as person's total contribution to the bill
            let totalContribution = people[index].getTotalContribution()
            var totalContributionString: String?
            if (totalContribution != totalContribution) {
                totalContributionString = "0.00"
            } else {
                totalContributionString = String(format: "%.02f", totalContribution)
            }
            cell!.detailTextLabel!.text = "$" + totalContributionString!
            
            return cell!
        }
    }
}












