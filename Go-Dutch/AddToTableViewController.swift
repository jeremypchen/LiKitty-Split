//
//  AddToTableViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/17/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class AddToTableViewController: UIViewController {
    let splitModel = SplitModel.sharedInstance
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addToTableButton: UIButton!
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var yNamePos: CGFloat?
    var nameCount = 0
    var existingPeople: [Person]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
         selector: #selector(keyboardShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        yNamePos = scrollView.frame.origin.y + 8

        existingPeople = splitModel.returnAllPeople()
        if existingPeople.count > 0 {
            addExistingPeopleLabels()
        }
        
        personNameTextField.becomeFirstResponder()
    }
    
    @IBAction func addToTableButtonPushed(sender: AnyObject) {
        let warningAlert = UIAlertController.init(
            title: "Error",
            message: "",
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) {(action) in }
        warningAlert.addAction(OKAction)
        
        // check if person name textfield is not empty
        if let personName = personNameTextField.text where !personName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty {
            
            // check if person name already at the table 
            if let _ = splitModel.returnPersonByName(personName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {

                warningAlert.message = "Person already at the table."
                
                let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
                rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
            } else {
                // otherwise, save
                splitModel.addPerson(Person(name: personName))
                
                animateLabelToPositionInList(personName)
                
                personNameTextField.text = ""
            }
        } else {
            // throw warning alert if it is empty
            warningAlert.message = "Person name cannot be empty."
            
            let rootViewController: UIViewController = (UIApplication.sharedApplication().windows.last?.rootViewController!)!
            rootViewController.presentViewController(warningAlert, animated: true, completion: nil)
        }
    }
    
    func animateLabelToPositionInList(name: String) {
        // create label with name at position of person name text field
        let personLabel = UILabel(frame: CGRectMake(personNameTextField.frame.origin.x,
            personNameTextField.frame.origin.y,
            personNameTextField.frame.width,
            personNameTextField.frame.height))
        
        personLabel.textAlignment = NSTextAlignment.Center
        personLabel.text = name
        personLabel.font = personLabel.font.fontWithSize(20)
        personLabel.textColor = UIColor.orangeColor()
        
        self.view.addSubview(personLabel)
        
        // animate to y_pos
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            personLabel.frame.origin.y = self.yNamePos!
            
            let first_x_pos = self.scrollView.frame.origin.x
            let second_x_pos = first_x_pos + self.scrollView.frame.width / 2
            
            if self.nameCount % 2 == 0 {
                personLabel.frame.origin.x = first_x_pos
            } else {
                personLabel.frame.origin.x = second_x_pos
                
                // increment y_pos
                self.yNamePos! += 30.0
            }
            
            self.nameCount += 1
        })
    }
    
    func addExistingPeopleLabels() {
        self.nameCount = existingPeople.count
        
        var personLabel: UILabel!
        let first_x_pos = self.scrollView.frame.origin.x
        let second_x_pos = first_x_pos + self.scrollView.frame.width / 2
        
        for i in 0...nameCount-1 {
            if i % 2 == 0 {
                personLabel = UILabel(frame:
                    CGRectMake(
                        first_x_pos,
                        self.yNamePos!,
                        personNameTextField.frame.width,
                        personNameTextField.frame.height))
            } else {
                personLabel = UILabel(frame:
                    CGRectMake(
                        second_x_pos,
                        self.yNamePos!,
                        personNameTextField.frame.width,
                        personNameTextField.frame.height))
                
                self.yNamePos! += 30.0
            }
            
            personLabel.textAlignment = NSTextAlignment.Center
            personLabel.text = existingPeople[i].getName()
            personLabel.font = personLabel.font.fontWithSize(20)
            personLabel.textColor = UIColor.orangeColor()
            
            self.view.addSubview(personLabel)
        }
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
