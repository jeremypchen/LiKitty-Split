//
//  SplitModel.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import Foundation

class SplitModel {
    static let sharedInstance = SplitModel()
    
    let DEFAULT_TAX_RATE = 0.08
    let DEFAULT_TIP_RATE = 0.15
    
    var savedPeople: [Person]!
    var savedItems: [String:Item]!
    var currentTaxRate: Double
    var currentTipRate: Double
    
    init() {
        print("SplitModel singleton initiated")
        
        currentTaxRate = DEFAULT_TAX_RATE
        currentTipRate = DEFAULT_TIP_RATE
        
    }
    
    /* PEOPLE */
    func addPerson(person: Person) {
        savedPeople.append(person)
    }
    
    func returnPersonByName(name: String) -> Person? {
        for p in savedPeople {
            if (p.getName() == name) {
                return p
            }
        }
        return nil
    }
    
    func returnAllPeople() -> [Person] {
        return savedPeople
    }
    
    /* MONEY */
    func getSubtotal() -> Double {
        
    }
    
    func getSubtotalMinusItemsWithTaxIncluded() -> Double {
        
    }
    
    func getTaxAmount() -> Double {
        
    }
    
    func getTipAmount() -> Double {
        
    }
    
    func getTaxRate() {
        
    }
    
    func getTipRate() {
        
    }
    
    func setTaxRate() {
        
    }
    
    func setTipRate() {
        
    }
    
    func getTotal() -> Double {
        return getSubtotal() + getTaxAmount() + getTipAmount()
    }
    
    /* ITEMS */
    func addItem(itemName: String,
        itemPrice: Double,
        peopleWithPercentage: [(Person,Double)],
        taxIncluded: Bool) -> Bool {
        
        if (createAndSaveItem(itemName, itemPrice: itemPrice)) {
            // For each person, add item with percentage
            for p in peopleWithPercentage {
                let person = p.0
                let percentage = p.1
                
                person.addFood(itemName, withPrice: itemPrice, withContribution: percentage)
            }
            
            return true
        }
        
        return false
    }
    
    // Returns all items
    func getAllItems() -> [String:Item] {
        return savedItems
    }
    
    // Return all item names
    func getAllItemNames() -> [String] {
        return [String](savedItems.keys)
    }
    
    // Returns item by name
    func getItemByName(itemName: String) -> Item {
        return savedItems[itemName]!
    }
    
    // Return number of items
    func getItemCount() -> Int {
        return savedItems.count
    }
    
    // Deletes item by name
    func deleteItem(itemName: String) {
        savedItems.removeValueForKey(itemName)
    }
    
    private func createAndSaveItem(itemName: String, itemPrice: Double) -> Bool {
        if (savedItems[itemName] != nil) {
            return false
        }
        
        let item = Item(itemName: itemName, itemPrice: itemPrice)
        savedItems[itemName] = item
        
        return true
    }
    
    
    
    
    
    
    // Save items and people into CoreData
    func save() {
        
    }
    

}













