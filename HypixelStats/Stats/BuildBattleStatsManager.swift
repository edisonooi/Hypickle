//
//  BuildBattleStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/21/21.
//

import Foundation
import UIKit
import SwiftyJSON

class BuildBattleStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        2: "",
        5: ""
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var wins = data["wins"].intValue
        var gamesPlayed = data["games_played"].intValue
        var losses = gamesPlayed - wins
        
        if losses < 0 {
            losses = 0
        }
        
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var titleAndColor = calculateTitle(score: data["score"].intValue)
        
        let winsDivisions = [
            ("Solo", data["wins_solo_normal"].intValue),
            ("Teams", data["wins_teams_normal"].intValue),
            ("Pro", data["wins_solo_pro"].intValue),
            ("Guess the Build", data["wins_guess_the_build"].intValue)
        ]
        
        return [
            CellData(headerData: ("Score", data["score"].intValue)),
            CellData(headerData: ("Title", titleAndColor.0), sectionData: [], color: titleAndColor.1),
            CellData(headerData: ("Overall Wins", wins), sectionData: winsDivisions),
            CellData(headerData: ("Overall Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            CellData(headerData: ("Total Votes Given", data["total_votes"].intValue)),
            CellData(headerData: ("Correct Guesses", data["correct_guesses"].intValue)),
            CellData(headerData: ("Super Votes", data["super_votes"].intValue)),
        ]
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return statsTableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statsTableData[section].isOpened {
            return statsTableData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
        cell.configureDefault(statsTableData: statsTableData, indexPath: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }

        return 41
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !statsTableData[indexPath.section].sectionData.isEmpty && indexPath.row == 0 {
            statsTableData[indexPath.section].isOpened = !statsTableData[indexPath.section].isOpened
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if statsTableData[indexPath.section].sectionData.isEmpty || indexPath.row != 0 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                return 32
            } else {
                return 64
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 32))
                headerView.backgroundColor = .clear
                
                return headerView
            } else {
                let headerView = GenericHeaderView.instanceFromNib()
                headerView.title.text = headerTitle
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func calculateTitle(score: Int) -> (String, UIColor) {
        if (0..<100).contains(score) {
            return ("Rookie", .label)
        } else if (100..<250).contains(score) {
            return ("Untrained", .systemGray)
        } else if (250..<500).contains(score) {
            return ("Amateur", UIColor.MinecraftColors.yellow)
        } else if (500..<1000).contains(score) {
            return ("Apprentice", UIColor.MinecraftColors.green)
        } else if (1000..<2000).contains(score) {
            return ("Experienced", UIColor.MinecraftColors.pink)
        } else if (2000..<3500).contains(score) {
            return ("Seasoned", UIColor.MinecraftColors.blue)
        } else if (3500..<5000).contains(score) {
            return ("Trained", UIColor.MinecraftColors.darkGreen)
        } else if (5000..<7500).contains(score) {
            return ("Skilled", UIColor.MinecraftColors.darkAqua)
        } else if (7500..<10000).contains(score) {
            return ("Talented", UIColor.MinecraftColors.red)
        } else if (10000..<15000).contains(score) {
            return ("Professional", UIColor.MinecraftColors.darkPurple)
        } else if (15000..<20000).contains(score) {
            return ("Expert", UIColor.MinecraftColors.darkBlue)
        } else if score >= 20000 {
            return ("Master", UIColor.MinecraftColors.darkRed)
        } //Check for title #1 buider
        
        
        return ("Rookie", .label)
        
    }
    
    
}
