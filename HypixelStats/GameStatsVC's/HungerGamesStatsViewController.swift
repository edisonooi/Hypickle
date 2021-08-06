//
//  HungerGamesStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/31/21.
//

import Foundation
import UIKit
import SwiftyJSON

class HungerGamesStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Blitz Survival Games"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var killsSolo = data["kills_solo_normal"].intValue ?? 0
        var killsTeams = data["kills_teams_normal"].intValue ?? 0
        var kills = data["kills"].intValue ?? 0
        var deaths = data["deaths"].intValue ?? 0
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        
        var winsSolo = data["wins_solo_normal"].intValue ?? 0
        var winsTeams = data["wins_teams_normal"].intValue ?? 0
        var wins = winsSolo + winsTeams
        
        var wlr = GameTypes.calculateRatio(numerator: wins, denominator: deaths)
        var killsPerGame = GameTypes.calculateRatio(numerator: kills, denominator: wins + deaths)
        
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
                
                var kitEXP = data["exp_" + kit].intValue ?? 0
                
                var kitWinsSolo = data["wins_" + kit].intValue ?? 0
                var kitWinsTeams = data["wins_teams_" + kit].intValue ?? 0
                var kitWins = kitWinsSolo + kitWinsTeams
                var kitGamesPlayed = data["games_played_" + kit].intValue ?? 0
                var kitLosses = kitGamesPlayed - kitWins
                var kitWLR = GameTypes.calculateRatio(numerator: kitWins, denominator: kitLosses)
                
                var kitKills = data["kills_" + kit].intValue ?? 0
                
                var kitTimePlayed = convertToHoursMinutesSeconds(seconds: data["time_played_" + kit].intValue ?? 0)
                
                var kitPrestige = data["p" + kit].intValue ?? 0
                var prestigeString = kitPrestige == 0 ? "" : GameTypes.convertToRomanNumerals(number: kitPrestige)
                
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
                
                kitStats.append(CellData(headerData: (kitName + " " + GameTypes.convertToRomanNumerals(number: kitLevel), prestigeString), sectionData: statsForThisKit, isHeader: false, isOpened: false))
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
        let cell = statsTable.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
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
            statsTable.reloadSections(sections, with: .none)
        }
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
    
    func convertToHoursMinutesSeconds(seconds: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    
}