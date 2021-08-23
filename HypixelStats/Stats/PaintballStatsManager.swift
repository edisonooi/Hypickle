//
//  PaintballStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import Foundation
import UIKit
import SwiftyJSON

class PaintballStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
       
        
        let shotsFired = data["shots_fired"].intValue
        
        var shotsPerKill = kills == 0 ? Double(shotsFired) : Double(shotsFired) / Double(kills)
        
        var headStart = data["headstart"].intValue
        
        if headStart == 0 {
            headStart = 1
        }
        
        return [
            [
                ("Wins", data["wins"].intValue)
            ],
            [
                ("Kills", kills),
                ("Deaths", deaths),
                ("K/D", kdr),
                ("Shots Fired", shotsFired),
                ("Shots/Kill", String(format: "%.2f", shotsPerKill))
            ],
            [
                ("Killstreaks", data["killstreaks"].intValue),
                ("Forcefield Time (seconds)", data["forcefieldTime"].intValue)
            ],
            [
                ("Adrenaline", (data["adrenaline"].intValue) + 1),
                ("Endurance", (data["endurance"].intValue) + 1),
                ("Fortune", (data["fortune"].intValue) + 1),
                ("Godfather", (data["godfather"].intValue) + 1),
                ("Head Start", headStart),
                ("Superluck", (data["superluck"].intValue) + 1),
                ("Transfusion", (data["transfusion"].intValue) + 1)
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
        
        if section == 3 {
            label.text = "Perks"
            label.backgroundColor = .systemPink
            return label
        }
        
        label.backgroundColor = .white
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
