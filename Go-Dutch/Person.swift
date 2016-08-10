//
//  Person.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//
class Person {
    private var name: String
    private var items: [String:Item]
    private var itemsWithPriceAndPercentage: [String:[String:Double]]
    let splitModel = SplitModel.sharedInstance
    
    init(name:String) {
        self.name = name
        self.items = [String:Item]()
        self.itemsWithPriceAndPercentage = [String:[String:Double]]()
    }
    
    init(name: String, items: [String:Item]) {
        self.name = name
        self.items = items
        self.itemsWithPriceAndPercentage = [String:[String:Double]]()
    }
    
    func addItem(item: Item, percentage: Double) {
        var itemDict:[String:Double] = ["Percentage": 0, "Price": 0]
        itemDict["Percentage"] = percentage
        itemDict["Price"] = item.itemPrice
        
        items[item.itemName] = item
        itemsWithPriceAndPercentage[item.itemName] = itemDict
    }
    
    func getAllItems() -> [String:Item] {
        return items
    }
    
    func getAllItemsWithPriceAndPercentages() -> [String:[String:Double]] {
        return itemsWithPriceAndPercentage
    }
    
    func deleteItemByName(itemName: String) {
        items.removeValueForKey(itemName)
        itemsWithPriceAndPercentage.removeValueForKey(itemName)
    }
    
    func getName() -> String {
        return name
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getTotalContribution() -> Double {
        var totalContribution = getSubtotal()
        
        totalContribution += getTaxAndTipContribution(totalContribution)
        
        return totalContribution
    }
    
    func getSubtotal() -> Double {
        var subtotal: Double = 0
        
        for (_, dict) in itemsWithPriceAndPercentage {
           subtotal += dict["Percentage"]! * dict["Price"]!
        }
        
        return subtotal
    }
    
    func getTaxContribution() -> Double {
        return getTotalPercentage() * splitModel.getTaxAmount()
    }
    
    func getTipContribution() -> Double {
        return getTotalPercentage() * splitModel.getTipAmount()
    }
    
    private func getTaxAndTipContribution(subtotal: Double) -> Double {
        let totalTaxAndTip: Double = splitModel.getTaxAmount() + splitModel.getTipAmount()
        
        return getTotalPercentage() * totalTaxAndTip
    }
    
    private func getTotalPercentage() -> Double {
        return getSubtotal()/splitModel.getSubtotal()
    }
    
}









