import UIKit

class VenmoViewController: UIViewController { //, UITableViewDelegate, UITableViewDataSource {
    let splitModel = SplitModel.sharedInstance
    
    @IBOutlet weak var tableOfNames: UITableView!
    @IBOutlet weak var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableOfNames.dataSource = self
//        tableOfNames.delegate = self
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return splitModel.returnAllPeople().count
//    }
//
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    }

}
