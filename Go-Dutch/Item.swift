//
//  Item.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

class Item {
    var itemName: String
    var itemPrice: Double
    var taxIncluded: Bool
    
    init(itemName: String, itemPrice: Double, taxIncluded: Bool) {
        self.itemName = itemName
        self.itemPrice = itemPrice
        self.taxIncluded = taxIncluded
    }
    
}