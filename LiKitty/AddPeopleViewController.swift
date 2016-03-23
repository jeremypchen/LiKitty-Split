//
//  AddPeopleViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class AddPeopleViewController: UIViewController {
    var splitModel: SplitModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitModel = SplitModel.sharedModel()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPersons() {
        
    }
    
    func doneButtonPressed() {
        
    }
    
    func animatePersonTextbox() {
        
    }
}