//
//  BuildBattleStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/21/21.
//

import Foundation
import UIKit
import SwiftyJSON

class BuildBattleStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Build Battle"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var desiredStats: [[(String, Any)]] = {
        
        var wins = data["wins"].doubleValue ?? 0.0
        var gamesPlayed = data["games_played"].doubleValue ?? 0.0
        var losses = gamesPlayed - wins
        var wlr = GameTypes.calculateKDR(kills: wins, deaths: losses)
        
        return [
            [
                ("Score", data["score"].intValue ?? 0),
                ("Title", calculateTitle(score: data["score"].intValue ?? 0)),
            ],
            [
                //Do a dropdown for win categories
                ("Overall Wins", data["wins"].intValue ?? 0),
                ("Overall Losses", Int(losses)),
                ("W/L", wlr),
            ],
            [
                ("Total Votes", data["total_votes"].intValue ?? 0),
                ("Correct Guesses", data["correct_guesses"].intValue ?? 0),
                ("Super Votes", data["super_votes"].intValue ?? 0),
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
    
    func calculateTitle(score: Int) -> String {
        if (0..<100).contains(score) {
            return "Rookie"
        } else if (100..<250).contains(score) {
            return "Untrained"
        } else if (250..<500).contains(score) {
            return "Amateur"
        } else if (500..<1000).contains(score) {
            return "Apprentice"
        } else if (1000..<2000).contains(score) {
            return "Experienced"
        } else if (2000..<3500).contains(score) {
            return "Seasoned"
        } else if (3500..<5000).contains(score) {
            return "Trained"
        } else if (5000..<7500).contains(score) {
            return "Skilled"
        } else if (7500..<10000).contains(score) {
            return "Talented"
        } else if (10000..<15000).contains(score) {
            return "Professional"
        } else if (15000..<20000).contains(score) {
            return "Expert"
        } else if score >= 20000 {
            return "Master"
        } //Check for title #1 buider
        
        
        return "Rookie"
        
    }
    
    
}
