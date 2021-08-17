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
            CellData(headerData: ("Wins (tap for details)", wins), sectionData: winsDivisions, isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills/Game", killsPerGame), sectionData: [], isHeader: false, isOpened: false)
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
                
                kitStats.append(CellData(headerData: (kitName + " " + Utils.convertToRomanNumerals(number: kitLevel), prestigeString), sectionData: statsForThisKit, isHeader: false, isOpened: false))
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
        
        if indexPath.row == 0 {
            let category = statsTableData[indexPath.section].headerData.0
            let value = statsTableData[indexPath.section].headerData.1
            cell.configure(category: category, value: "\(value)")
        } else {
            let category = statsTableData[indexPath.section].sectionData[indexPath.row - 1].0
            let value = statsTableData[indexPath.section].sectionData[indexPath.row - 1].1
            cell.configure(category: category, value: "\(value)")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !statsTableData[indexPath.section].sectionData.isEmpty && indexPath.row == 0 {
            statsTableData[indexPath.section].isOpened = !statsTableData[indexPath.section].isOpened
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if statsTableData[indexPath.section].sectionData.isEmpty || indexPath.row != 0 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionsThatNeedHeader = [3, 7]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
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
