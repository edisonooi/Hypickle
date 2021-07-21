//
//  PaintballStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import Foundation
import UIKit
import SwiftyJSON

class PaintballStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Paintball"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var kills = data["kills"].doubleValue ?? 0.0
        var deaths = data["deaths"].doubleValue ?? 0.0
        
        var kdr = 0.0
        if kills == 0.0 && deaths == 0.0 {
            kdr = 0.0
        } else if kills != 0.0 && deaths == 0 {
            kdr = kills
        } else {
            kdr = kills / deaths
        }
        
        let shotsFired = data["shots_fired"].doubleValue ?? 0.0
        
        var shotsPerKill = kills == 0.0 ? shotsFired : shotsFired / kills
        
        return [
            [
                ("Wins", data["wins"].intValue ?? 0)
            ],
            [
                ("Kills", data["kills"].intValue ?? 0),
                ("Deaths", data["deaths"].intValue ?? 0),
                ("K/D", String(format: "%.2f", kdr)),
                ("Shots Fired", data["shots_fired"].intValue ?? 0),
                ("Shots/Kill", String(format: "%.2f", shotsPerKill))
            ],
            [
                ("Killstreaks", data["killstreaks"].intValue ?? 0),
                ("Forcefield Time (seconds)", data["forcefieldTime"].intValue ?? 0)
            ],
            [
                ("Adrenaline", (data["adrenaline"].intValue ?? 0) + 1),
                ("Endurance", (data["endurance"].intValue ?? 0) + 1),
                ("Fortune", (data["fortune"].intValue ?? 0) + 1),
                ("Godfather", (data["godfather"].intValue ?? 0) + 1),
                ("Head Start", data["headstart"].intValue ?? 0),
                ("Superluck", (data["superluck"].intValue ?? 0) + 1),
                ("Transfusion", (data["transfusion"].intValue ?? 0) + 1)
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
        
        if section == 3 {
            label.text = "Perks"
            label.backgroundColor = .systemPink
            return label
        }
        
        label.backgroundColor = .white
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    
}
