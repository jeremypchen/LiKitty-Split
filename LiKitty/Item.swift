//
//  Item.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import Foundation

class Item {
    var itemName: String?
    var itemPrice: Double?
    
    init(itemName: String, itemPrice: Double) {
        self.itemName! = itemName
        self.itemPrice! = itemPrice
    }
    
}