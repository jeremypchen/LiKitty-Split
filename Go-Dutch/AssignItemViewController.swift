//
//  AssignItemViewController.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/17/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class AssignItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let splitModel = SplitModel.sharedInstance
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var peopleTableView: UITableView!
    
    var indexOfItems: Int = 0
    var people: [Person]?
    var currentItem: Item!
    var pageIndex: Int!
    var progressViewProgress: Float!
    var selectedCells: [Int:PersonCell] = [Int:PersonCell]()
    var existingPeopleWithPerc: [(Person, Double)] = [(Person, Double)]()
    
//    var weightsHaveBeenEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemName = currentItem.itemName
        
        people = splitModel.returnAllPeople()
        
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        
        progressView.progress = progressViewProgress
        
        existingPeopleWithPerc = splitModel.returnPeopleForItem(currentItem)
        unassignItemForAllPeople()
        
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.text = "Who had the " + itemName + "?"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splitModel.returnAllPeople().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonCell"
        
        var cell = peopleTableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PersonCell?
        if cell == nil {
            cell = PersonCell.init(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        cell!.person = people![indexPath.row]
        cell!.nameLabel.text = people![indexPath.row].getName()
        cell!.selectionStyle = UITableViewCellSelectionStyle.None

        if (existingPeopleWithPerc.isEmpty ||
            contains(existingPeopleWithPerc, p: cell!.person!) == -1) {
            cell!.nameLabel.textColor = UIColor.lightGrayColor()
            
            cell!.percentageLabel.hidden = true
            
            cell!.tag = 0
        } else {
            cell!.nameLabel.textColor = UIColor.orangeColor()
            
            cell!.percentageLabel.hidden = false
            
            cell!.setPercentage(Int(contains(existingPeopleWithPerc, p: cell!.person!)!*100))
            
            selectedCells[indexPath.row] = cell!
            
            cell!.tag = 1
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: PersonCell = tableView.cellForRowAtIndexPath(indexPath) as! PersonCell

        if (selectedCell.tag == 0) {
            selectedCell.tag = 1
            
            selectedCell.nameLabel.textColor = UIColor.orangeColor()
            
            selectedCell.percentageLabel.hidden = false
            
            selectedCells[indexPath.row] = selectedCell
            recalculateWeights(selectedCell)
        } else if (selectedCell.tag == 1) {
            selectedCell.tag = 0
            
            selectedCell.nameLabel.textColor = UIColor.lightGrayColor()
            
            selectedCell.percentageLabel.hidden = true
            
            selectedCells.removeValueForKey(indexPath.row)
            recalculateWeights(selectedCell)
        }
    }
    
    func recalculateWeights(selectedCell: PersonCell) {
        // adjust weights
        if selectedCells.count != 0 {
            let recalculatedWeight: Int = Int(floor(100.0/Double(selectedCells.count)))
            var remainder = 100 % selectedCells.count
            
            for c in selectedCells {
                if (remainder > 0) {
                    c.1.setPercentage(recalculatedWeight + 1)
                    remainder -= 1
                } else {
                    c.1.setPercentage(recalculatedWeight)
                }
            }
        }
    }
    
    func savePeopleAndPercentages() {
        // if going to next item, save people and percentages for this item
        for s in selectedCells {
            let cell = s.1
            let percentage = Double(cell.returnPercentage())/100
            
            splitModel.assignItemForPerson(currentItem, person: cell.person!, percentage: percentage)
        }
    }
    
    func unassignItemForAllPeople() {
        for p in people! {
            p.deleteItemByName(currentItem.itemName)
        }
    }
    
    func contains(personsWithPercentage: [(Person, Double)], p: Person) -> Double? {
        for (person, percentage) in personsWithPercentage {
            if person.getName() == p.getName() {
                return percentage
            }
        }
        return -1
    }

}
