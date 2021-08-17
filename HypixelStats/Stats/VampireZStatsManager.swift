//
//  VampireZStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/21/21.
//

import Foundation
import UIKit
import SwiftyJSON

class VampireZStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var humanKills = data["human_kills"].intValue
        var humanDeaths = data["human_deaths"].intValue
        
        var humanKDR = Utils.calculateRatio(numerator: humanKills, denominator: humanDeaths)
        
        var vampireKills = data["vampire_kills"].intValue
        var vampireDeaths = data["vampire_deaths"].intValue
        
        var vampireKDR = Utils.calculateRatio(numerator: vampireKills, denominator: vampireDeaths)
        
        return [
            [
                ("Human Wins", data["human_wins"].intValue),
                ("Human Kills", humanKills),
                ("Human Deaths", humanDeaths),
                ("Human K/D", humanKDR),
                ("Zombie Kills", data["zombie_kills"].intValue)
            ],
            [
                ("Vampire Wins", data["vampire_wins"].intValue),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
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
