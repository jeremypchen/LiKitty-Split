//
//  SplitModel.swift
//  LiKitty
//
//  Created by Jeremy Chen on 3/23/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//
class SplitModel {
    static let sharedInstance = SplitModel()
    
    private var savedPeople = [Person]()
    private var savedItems = [String:Item]()
    private var currentTaxAmount: Double
    private var currentTipAmount: Double
    
    init() {        
        currentTaxAmount = 0
        currentTipAmount = 0
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
    
    func assignItemForPerson(item: Item, person: Person, percentage: Double) {
        person.addItem(item, percentage: percentage)
    }
        
    func returnPeopleForItem(item: Item) -> [(Person, Double)] {
        var peeps = [(Person,Double)]()
        
        for p in savedPeople {
            let items = p.getAllItemsWithPriceAndPercentages()
            if items.keys.contains(item.itemName) {
                let percentage = items[item.itemName]!["Percentage"]
                
                peeps.append((p, percentage!))
            }
        }
        
        return peeps
    }
    
    /* MONEY */
    func getSubtotal() -> Double {
        var subtotal: Double = 0
        
        for (_, item) in savedItems {
            subtotal += item.itemPrice
        }
        
        return subtotal
    }
    
    func getSubtotalMinusItemsWithTaxIncluded() -> Double {
        var subtotal: Double = 0
        
        for (_, item) in savedItems {
            if (!item.taxIncluded) {
                subtotal += item.itemPrice
            }
        }
        
        return subtotal
    }
    
    func getTaxAmount() -> Double {
        return currentTaxAmount
    }
    
    func getTipAmount() -> Double {
        return currentTipAmount
    }
    
    func setTaxAmount(taxAmount: Double) {
        currentTaxAmount = taxAmount
    }
    
    func setTipAmount(tipAmount: Double) {
        currentTipAmount = tipAmount
    }
    
    func getTotal() -> Double {
        return getSubtotal() + getTaxAmount() + getTipAmount()
    }
    
    func reset() {
        currentTaxAmount = 0
        currentTipAmount = 0
        
        savedItems.removeAll()
        savedPeople.removeAll()
    }
    
    /* ITEMS */
    func addItem(itemName: String,
        itemPrice: Double,
        peopleWithPercentage: [(Person,Double)],
        taxIncluded: Bool) -> Bool {
            
        if let createdItem = createAndSaveItem(itemName, itemPrice: itemPrice, taxIncluded: taxIncluded) {
            // For each person, add item with percentage
            for p in peopleWithPercentage {
                let person = p.0
                let percentage = p.1
                
                person.addItem(createdItem, percentage: percentage)
            }
            return true
        }
            
        // Throw error
        return false
    }
    
    func addItem(itemName: String,
                 itemPrice: Double,
                 taxIncluded: Bool) -> Bool {
        
        if let _ = createAndSaveItem(itemName, itemPrice: itemPrice, taxIncluded: taxIncluded) {
            // For each person, add item with percentage
            return true
        }
        
        // Throw error
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
    
    func getAllItemsAsArray() -> [Item] {
        return Array(savedItems.values)
    }
    
    func getItemAtIndex(index: Int) -> Item {
        let itemsInArray = Array(savedItems.keys)
        let keyAtIndex = itemsInArray[index]
        return savedItems[keyAtIndex]!
    }
    
    func getItemNameAtIndex(index: Int) -> String {
        let itemsInArray = Array(savedItems.keys)
        
        return itemsInArray[index]
    }
    
    func getItemPriceAtIndex(index: Int) -> Double {
        // convert map to array
        let itemsInArray = Array(savedItems.keys)
        let keyAtIndex = itemsInArray[index]
        let itemDict = savedItems[keyAtIndex]
        return itemDict!.itemPrice
    }
    
    // Returns item by name
    func getItemByName(itemName: String) -> Item? {
        return savedItems[itemName]
    }
    
    // Return number of items
    func getItemCount() -> Int {
        return savedItems.count
    }
    
    func itemNameAlreadyUsed(itemName: String) -> Bool {
        return savedItems[itemName] != nil
    }
    
    // Deletes item by name
    func deleteItem(itemName: String) {
        savedItems.removeValueForKey(itemName)
    }
    
    private func createAndSaveItem(itemName: String,
        itemPrice: Double,
        taxIncluded: Bool) -> Item? {
        if (savedItems[itemName] != nil) {
            return nil
    }
        
        let item = Item(itemName: itemName,
            itemPrice: itemPrice,
            taxIncluded: taxIncluded)
            
        savedItems[itemName] = item
        
        return item
    }
    
    
    
    
    
    
    // Save items and people into CoreData
    func save() {
        
    }
    

}













