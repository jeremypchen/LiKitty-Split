import UIKit

class VenmoPersonCell: UITableViewCell {
    @IBOutlet weak var venmoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var linkVenmoButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLabels(personName: String, amount: Double) {
        nameLabel.text = personName
        amountLabel.text = String(format:"$%.2f", amount)
        
    }
    
    @IBAction func touchedLinkVenmoButton(sender: AnyObject) {
        
        // If successful, change value
    }
    
}
