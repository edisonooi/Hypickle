//
//  HungerGamesStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/31/21.
//

import Foundation
import UIKit
import SwiftyJSON

class HungerGamesStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        7: "Kits"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var killsSolo = data["kills_solo_normal"].intValue
        var killsTeams = data["kills_teams_normal"].intValue
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var winsSolo = data["wins_solo_normal"].intValue
        var winsTeams = data["wins_teams_normal"].intValue
        var wins = winsSolo + winsTeams
        
        var wlr = Utils.calculateRatio(numerator: wins, denominator: deaths)
        var killsPerGame = Utils.calculateRatio(numerator: kills, denominator: wins + deaths)
        
        let winsDivisions = [
            ("Solo", winsSolo),
            ("Teams", winsTeams),
        ]
        
        var generalStats = [
            CellData(headerData: ("Wins (tap for details)", wins), sectionData: winsDivisions),
            CellData(headerData: ("Losses", deaths)),
            CellData(headerData: ("W/L", wlr)),
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("Kills/Game", killsPerGame))
        ]
        
        ret.append(contentsOf: generalStats)
        
        var kitNames = [
            "arachnologist",
            "archer",
            "armorer",
            "astronaut",
            "baker",
            "blaze",
            "creepertamer",
            "diver",
            "donkeytamer",
            "farmer",
            "fisherman",
            "florist",
            "golem",
            "guardian",
            "horsetamer",
            "hunter",
            "hype train",
            "jockey",
            "knight",
            "meatmaster",
            "necromancer",
            "paladin",
            "phoenix",
            "pigman",
            "ranger",
            "reaper",
            "reddragon",
            "rogue",
            "scout",
            "shadow knight",
            "slimeyslime",
            "snowman",
            "speleologist",
            "tim",
            "toxicologist",
            "troll",
            "viking",
            "warlock",
            "warrior",
            "wolftamer"
        ]
        //Add chaos stats?
        var desiredStats = ["EXP", "Wins", "Losses", "W/L", "Kills", "Time Played"]
        
        var kitStats: [CellData] = []
        
        
        for kit in kitNames {
            var statsForThisKit: [(String, Any)] = []
            
            if data[kit].exists() || (data["time_played_" + kit].exists() && data["time_played_" + kit].intValue != 0) {
                
                var kitEXP = data["exp_" + kit].intValue
                
                var kitWinsSolo = data["wins_" + kit].intValue
                var kitWinsTeams = data["wins_teams_" + kit].intValue
                var kitWins = kitWinsSolo + kitWinsTeams
                var kitGamesPlayed = data["games_played_" + kit].intValue
                var kitLosses = kitGamesPlayed - kitWins
                var kitWLR = Utils.calculateRatio(numerator: kitWins, denominator: kitLosses)
                
                var kitKills = data["kills_" + kit].intValue
                
                var kitTimePlayed = Utils.convertToHoursMinutesSeconds(seconds: data["time_played_" + kit].intValue)
                
                var kitPrestige = data["p" + kit].intValue
                var prestigeString = kitPrestige == 0 ? "" : Utils.convertToRomanNumerals(number: kitPrestige)
                
                var kitLevel = data[kit].intValue + 1
                
                if !data[kit].exists() {
                    kitLevel = calculateKitLevel(kitEXP: kitEXP)
                }
                
                var color = UIColor.label
                
                if kitLevel == 10 {
                    color = .systemRed
                }
                
                var dataForThisKit = [kitEXP, kitWins, kitLosses, kitWLR, kitKills, kitTimePlayed] as [Any]
                
                for (index, category) in desiredStats.enumerated() {
                    statsForThisKit.append((category, dataForThisKit[index]))
                }
                
                var kitName: String
                
                switch kit {
                    case "reddragon":
                        kitName = "RedDragon"
                    case "slimeyslime":
                        kitName = "SlimeySlime"
                    default:
                        kitName = kit.capitalized
                }
                
                kitStats.append(CellData(headerData: (kitName + " " + Utils.convertToRomanNumerals(number: kitLevel), prestigeString), sectionData: statsForThisKit, color: color))
            }
        }
        
        ret.append(contentsOf: kitStats)
    
        return ret
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
        
        var category = ""
        var value: Any = ""
        
        if indexPath.row == 0 {
            if !statsTableData[indexPath.section].sectionData.isEmpty {
                cell.showDropDown()
            }
            
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
            
            if statsTableData[indexPath.section].color != .label {
                cell.statCategory.textColor = statsTableData[indexPath.section].color
                cell.statCategory.font = UIFont.boldSystemFont(ofSize: 17)
                cell.statValue.textColor = statsTableData[indexPath.section].color
            }
            
        } else {
            category = statsTableData[indexPath.section].sectionData[indexPath.row - 1].0
            value = statsTableData[indexPath.section].sectionData[indexPath.row - 1].1
            
            cell.statCategory.textColor = UIColor(named: "gray_label")
            cell.statCategory.font = UIFont.systemFont(ofSize: 14)
            cell.statValue.textColor = UIColor(named: "gray_label")
            cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
            
        }
        
        if value is Int {
            value = (value as! Int).withCommas
        }
        
        cell.configure(category: category, value: "\(value)")

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
                
                if headerTitle == "Kits" {
                    headerView.rightLabel.text = "Prestige"
                }
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func calculateKitLevel(kitEXP: Int) -> Int {
        let xpThresholds = [0, 100, 250, 500, 1000, 1500, 2000, 2500, 5000, 10000]
        
        var level = 0
        
        for threshold in xpThresholds {
            if kitEXP >= threshold {
                level += 1
            } else {
                break
            }
        }
        
        return level
    }
    
    
    
    
}
