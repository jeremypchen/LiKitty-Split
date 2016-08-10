//
//  PersonCell.swift
//  LiKitty
//
//  Created by Jeremy Chen on 4/18/16.
//  Copyright © 2016 Jeremy Chen. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var person: Person?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func returnPercentage() -> Int {
        return Int((percentageLabel.text?.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "%")))!)!
    }
    
    func setPercentage(percentage: Int) {
        percentageLabel.text = String(percentage) + "%"
    }
}
