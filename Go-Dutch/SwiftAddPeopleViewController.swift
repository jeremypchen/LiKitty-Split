//
//  SwiftAddPeopleViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class SwiftAddPeopleViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var peopleScrollView: UIScrollView!
    var peopleTextFields: [UITextField] = []
    var weightTextFields: [UITextField] = []
    
    let splitModel = SplitModel.sharedInstance
    
    var peopleLabel_YPOS: Int!
    var weightsHaveBeenEdited: Bool!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleLabel_YPOS = 70
        weightsHaveBeenEdited = false
        
        // Add initial person and weight textfields
        let firstPersonTextField = UITextField.init(frame: CGRectMake(8, 32, 220, 30))
        firstPersonTextField.borderStyle = UITextBorderStyle.RoundedRect
        firstPersonTextField.placeholder = "Name"
        firstPersonTextField.returnKeyType = UIReturnKeyType.Go
        firstPersonTextField.tag = 3
        firstPersonTextField.delegate = self
        
        let firstWeightTextField = UITextField.init(frame: CGRectMake(265, 32, 50, 30))
        firstWeightTextField.borderStyle = UITextBorderStyle.RoundedRect
        firstWeightTextField.text = "100"
        firstWeightTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        firstWeightTextField.keyboardType = UIKeyboardType.NumberPad
        firstWeightTextField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents:
            UIControlEvents.EditingChanged)
        
        peopleScrollView.addSubview(firstPersonTextField)
        peopleScrollView.addSubview(firstWeightTextField)
        
        // Initialize the people and weight textfields arrays with these initial textfields
        peopleTextFields.append(firstPersonTextField)
        weightTextFields.append(firstWeightTextField)
        
        // Single tap used to escape keyboard when user clicks on scrollview
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector (singleTapGestureCaptured))
        
        view.addGestureRecognizer(singleTap)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange() {
        weightsHaveBeenEdited = true
    }
    
    
    func singleTapGestureCaptured(gesture: UITapGestureRecognizer) {
        self.view .endEditing(true)
    }
    
    @IBAction func backgroundButtonPushed(sender: AnyObject) {
        for p in peopleTextFields {
            p.resignFirstResponder()
        }
        for w in weightTextFields {
            w.resignFirstResponder()
        }
    }
    
    
    @IBAction func addPersonButtonPushed(sender: AnyObject) {
        // Add two textfields to scroll view at proper height
        let newPersonTextField = UITextField.init(frame:CGRectMake(8, CGFloat(peopleLabel_YPOS), 220, 30))
        newPersonTextField.borderStyle = UITextBorderStyle.RoundedRect
        newPersonTextField.placeholder = "Name"
        newPersonTextField.returnKeyType = UIReturnKeyType.Go
        newPersonTextField.delegate = self
        newPersonTextField.tag = 3
        
        let newWeightTextField = UITextField.init(frame: CGRectMake(265, CGFloat(peopleLabel_YPOS), 50, 30))
        newWeightTextField.borderStyle = UITextBorderStyle.RoundedRect
        newWeightTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        newWeightTextField.keyboardType = UIKeyboardType.DecimalPad
        newWeightTextField.addTarget(self, action: #selector (textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        
        // Increment so next couple won't intersect
        peopleLabel_YPOS! += 38
        
        newPersonTextField.tag = peopleLabel_YPOS
        
        // Add to textfield arrays and to the scrollview
        peopleTextFields.append(newPersonTextField)
        weightTextFields.append(newWeightTextField)
        peopleScrollView.addSubview(newPersonTextField)
        peopleScrollView.addSubview(newWeightTextField)
        
        if (weightsHaveBeenEdited!) {
            var totalSoFar: Int = 0
            for w in weightTextFields {
                totalSoFar += Int(w.text!)!
            }
            if (100 - totalSoFar > 0) {
                newWeightTextField.text! = String(100-totalSoFar)
            } else {
                newWeightTextField.text! = "0"
            }
        } else {
            let recalculatedWeight: Int = Int(floor(100.0/Double(weightTextFields.count)))
            var remainder = 100 % weightTextFields.count
            
            for w in weightTextFields {
                if (remainder > 0) {
                    w.text = String(recalculatedWeight+1)
                    remainder -= 1
                } else {
                    w.text = String(recalculatedWeight)
                }
            }
        }
    }
    
    func textFieldShouldReturn(textfield: UITextField)-> Bool {
        if(textfield.tag == 3) {
            if (shouldPerformSegueWithIdentifier("PeopleValidated", sender: textfield)) {
            performSegueWithIdentifier("PeopleValidated", sender: self)
            }
        }
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        var atLeastOneNameSuccessful = false
        var peopleWithPercentages = [(Person, Double)]()
        
        var totalWeight = 0
        
        for w in weightTextFields {
            if w.text != nil {
                totalWeight += Int(w.text!)!
            }
        }
        
        if (totalWeight != 100) {
            // Error message if it doesn't add up to 100
//            let warningAlert = UIAlertView.init(title: "Error", message: "Weights don't add up to 100", delegate: nil, cancelButtonTitle: "OK")
            
//            warningAlert.show()
            return false
        }
        
        // For each textfield with name filled
        for i in 0 ..< peopleTextFields.count {
            if (peopleTextFields[i].text != "") && (weightTextFields[i].text != "") {
                // We have at least one filled people/weight textfield
                atLeastOneNameSuccessful = true
                
                let name: String! = peopleTextFields[i].text
                let weight = Double(weightTextFields[i].text!)!/100
                
                if let person = splitModel.returnPersonByName(name) {
                    // If person already exists, we don't need to add it to the model
                    print("Person named ", name, " already exists. Adding with weight ", weight)
                    peopleWithPercentages.append((person, weight))
                    
                    person.addItem(item!, percentage: weight)
                } else {
                     // If person doesn't exist, we create a new one and add it to the model
                    let newPerson = Person(name: name)
                    newPerson.addItem(item!, percentage: weight)
                    
                    peopleWithPercentages.append((newPerson, weight))
                    splitModel.addPerson(newPerson)
                }
            } else if (peopleTextFields[i].text == "") && (weightTextFields[i].text != "") {
//                let warningAlert = UIAlertView.init(title: "Error", message: "A corresponding name field is empty", delegate: nil, cancelButtonTitle: "OK")
                
//                warningAlert.show()
                return false
            } else if (peopleTextFields[i].text != "") && (weightTextFields[i].text == "") {
//                let warningAlert = UIAlertView.init(title: "Error", message: "A corresponding weight field is empty", delegate: nil, cancelButtonTitle: "OK")
                
//                warningAlert.show()
                return false
            }
        }
        
        if (atLeastOneNameSuccessful) {
            let x = splitModel.getItemByName(item!.itemName)
            if x == nil {
                // Add new entry to model
                splitModel.addItem(item!.itemName,
                                   itemPrice: item!.itemPrice,
                                   peopleWithPercentage: peopleWithPercentages,
                                   taxIncluded: item!.taxIncluded)
            }
            return true
        } else {
//            let warningAlert = UIAlertView.init(title: "Error", message: "You need to include at least one person's name and his/her corresponding weight", delegate: nil, cancelButtonTitle: "OK")
            
//            warningAlert.show()
            return false
        }
    }
    
}


































