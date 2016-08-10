//
//  SwiftVenmoViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/31/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit
//import Veqnmo_iOS_SDK

class SwiftVenmoViewController2: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let splitModel = SplitModel.sharedInstance
//    let venmoModel = Venmo.sharedInstance()
    
    var peopleDicts: NSMutableArray = []
    var textFields = [UITextField]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        venmoModel.defaultTransactionMethod = VENTransactionMethod.API
        
        textFields = [UITextField]()

        loadUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func loadUI() {
        var rowHeight: CGFloat = 8
        var index = 0
        
        splitModel.returnAllPeople().forEach({p in
            // Name of person
            let nameLabel = UILabel(frame: CGRectMake(8, rowHeight, 78, 24))
            nameLabel.textColor = UIColor.blackColor()
            nameLabel.text = p.getName()
            nameLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size:18)
            
            // How much this person owes
            let chargeLabel = UILabel(frame: CGRectMake(127, rowHeight, 66, 22))
            chargeLabel.textColor = UIColor.blackColor()
            chargeLabel.text = String(format: "$%.02f", p.getTotalContribution())
            chargeLabel.textAlignment = NSTextAlignment.Right
            chargeLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size:18)
            
            // Button to link with Venmo
            let venmoLinkButton = UIButton(frame: CGRectMake(205, rowHeight - 5, 111, 30))
            venmoLinkButton.setTitle("Link with Venmo friend", forState: UIControlState.Normal)
            venmoLinkButton.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size:18)
            venmoLinkButton.tag = index
            
            // Loading indicator
            let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            loadingIndicator.frame = CGRectMake(8, rowHeight+30, 20, 20)
            
            rowHeight += 72
            
            self.scrollView?.addSubview(nameLabel)
            self.scrollView?.addSubview(chargeLabel)
            self.scrollView?.addSubview(venmoLinkButton)
            self.scrollView?.addSubview(loadingIndicator)

            let pDict = [:]
            pDict.setValue(p.getName(), forKey: "Name")
            pDict.setValue(p.getTotalContribution(), forKey: "Charge")
            pDict.setValue(nameLabel, forKey: "NameLabel")
            pDict.setValue(chargeLabel, forKey: "ChargeLabel")
            pDict.setValue(loadingIndicator, forKey: "LoadingIndicator")
            pDict.setValue(false, forKey: "RequestSent")
            
            peopleDicts.addObject(pDict)
            
            index += 1
        })
    }
    
    // MARK: Actions
    @IBAction func payButtonPushed(sender: UIButton) {
//        peopleDicts.map({ p in
//            if (p.objectForKey("RequestSent" == false) {
//            p.objectForKey("LoadingIndicator")?.startAnimating()
//            
//            }
//            
//        })
    }
    
}
