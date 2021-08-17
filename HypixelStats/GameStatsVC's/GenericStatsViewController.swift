//
//  GenericStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit
import SwiftyJSON

class GenericStatsViewController: UIViewController {
        
    var data: JSON = [:]
    var achievementsData: JSON = [:]
    var gameID: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statsTable: UITableView!
    
    
    lazy var dataManager: StatsManager = {
        switch gameID {
        case "Bedwars":
            return BedwarsStatsManager(data: data)
        
        default:
            print("hello")
        }
        return BedwarsStatsManager(data: data)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTable.allowsSelection = true
    
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        titleLabel.text = GameTypes.databaseNameToCleanName[gameID]
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.dataSource = dataManager
        statsTable.delegate = dataManager
        
        
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
