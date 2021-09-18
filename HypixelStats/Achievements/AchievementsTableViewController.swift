//
//  AchievementsTableViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import UIKit
import SwiftyJSON

class AchievementsTableViewController: UITableViewController {
    
    var data: JSON = [:]

    @IBOutlet var achievementsTable: NonScrollingTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    

    

}
