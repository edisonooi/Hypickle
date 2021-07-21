//
//  GenericStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit
import SwiftyJSON

class GenericStatsViewController: UIViewController {
    
    var data: JSON = ["": ""]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTable.allowsSelection = false
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
