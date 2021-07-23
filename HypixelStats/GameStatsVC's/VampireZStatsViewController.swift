//
//  VampireZStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/21/21.
//

import Foundation
import UIKit
import SwiftyJSON

class VampireZStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "VampireZ"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var humanKills = data["human_kills"].intValue ?? 0
        var humanDeaths = data["human_deaths"].intValue ?? 0
        
        var humanKDR = GameTypes.calculateKDR(kills: humanKills, deaths: humanDeaths)
        
        var vampireKills = data["vampire_kills"].intValue ?? 0
        var vampireDeaths = data["vampire_deaths"].intValue ?? 0
        
        var vampireKDR = GameTypes.calculateKDR(kills: vampireKills, deaths: vampireDeaths)
        
        return [
            [
                ("Human Wins", data["human_wins"].intValue ?? 0),
                ("Human Kills", humanKills),
                ("Human Deaths", humanDeaths),
                ("Human K/D", humanKDR),
                ("Zombie Kills", data["zombie_kills"].intValue ?? 0)
            ],
            [
                ("Vampire Wins", data["vampire_wins"].intValue ?? 0),
                ("Vampire Kills", vampireKills),
                ("Vampire Deaths", vampireDeaths),
                ("Vampire K/D", vampireKDR)
            ]
        ]
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return desiredStats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desiredStats[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statsTable.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        let category = desiredStats[indexPath.section][indexPath.row].0
        let value = desiredStats[indexPath.section][indexPath.row].1
        cell.configure(category: category, value: "\(value)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.backgroundColor = .white
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
