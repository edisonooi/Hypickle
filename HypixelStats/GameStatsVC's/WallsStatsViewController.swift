//
//  WallsStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/21/21.
//

import Foundation
import UIKit
import SwiftyJSON

class WallsStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Walls"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var wins = data["wins"].intValue ?? 0
        var losses = data["losses"].intValue ?? 0
        var wlr = GameTypes.calculateKDR(kills: wins, deaths: losses)
        
        var kills = data["kills"].intValue ?? 0
        var deaths = data["deaths"].intValue ?? 0
        var kdr = GameTypes.calculateKDR(kills: kills, deaths: deaths)
        
        return [
            [
                ("Wins", data["wins"].intValue ?? 0),
                ("Losses", data["losses"].intValue ?? 0),
                ("W/L", wlr),
            ],
            [
                ("Kills", data["kills"].intValue ?? 0),
                ("Assists", data["assists"].intValue ?? 0),
                ("Deaths", data["deaths"].intValue ?? 0),
                ("K/D", kdr)
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
