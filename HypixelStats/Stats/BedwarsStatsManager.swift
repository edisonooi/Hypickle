//
//  BedwarsStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/14/21.
//

import Foundation
import UIKit
import SwiftyJSON

class BedwarsStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    var modeCount = 5
    var dreamsModeCount = 13
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins_bedwars"].intValue
        var losses = data["losses_bedwars"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills_bedwars"].intValue
        var deaths = data["deaths_bedwars"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var finalKills = data["final_kills_bedwars"].intValue
        var finalDeaths = data["final_deaths_bedwars"].intValue
        var finalKDR = Utils.calculateRatio(numerator: finalKills, denominator: finalDeaths)
        
        var level = getLevel(xp: data["Experience"].intValue + data["Experience_new"].intValue)
        var prestige = getPrestige(level: level)
        
        
        var generalStats = [
            
            CellData(headerData: ("Level", String(format: "%.2f", level)), sectionData: []),
            CellData(headerData: ("Prestige", prestige), sectionData: []),
            
            CellData(headerData: ("Wins", wins), sectionData: []),
            CellData(headerData: ("Losses", losses), sectionData: []),
            CellData(headerData: ("W/L", wlr), sectionData: []),
            
            CellData(headerData: ("Current Winstreak", data["winstreak"].intValue), sectionData: []),
            
            CellData(headerData: ("Kills", kills), sectionData: []),
            CellData(headerData: ("Deaths", deaths), sectionData: []),
            CellData(headerData: ("K/D", kdr), sectionData: []),
            CellData(headerData: ("Final Kills", finalKills), sectionData: []),
            CellData(headerData: ("Final Deaths", finalDeaths), sectionData: []),
            CellData(headerData: ("Final K/D", finalKDR), sectionData: []),
            
            CellData(headerData: ("Beds Broken", data["beds_broken_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Beds Lost", data["beds_lost_bedwars"].intValue), sectionData: []),
            
            CellData(headerData: ("Iron Collected", data["iron_resources_collected_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Gold Collected", data["gold_resources_collected_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Diamonds Collected", data["diamond_resources_collected_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Emeralds Collected", data["emerald_resources_collected_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Wrapped Presents Collected", data["wrapped_present_resources_collected_bedwars"].intValue), sectionData: []),
            CellData(headerData: ("Shop Purchases", data["_items_purchased_bedwars"].intValue), sectionData: []),
            
            
        ]
        
        ret.append(contentsOf: generalStats)
        
        var modes = [
            (id: "eight_one_", name: "Solo"),
            (id: "eight_two_", name: "Doubles"),
            (id: "four_three_", name: "3v3v3v3"),
            (id: "four_four_", name: "4v4v4v4"),
            (id: "two_four_", name: "4v4"),

            (id: "eight_one_rush_", name: "Rush Solo"),
            (id: "eight_two_rush_", name: "Rush Doubles"),
            (id: "four_four_rush_", name: "Rush 4v4v4v4"),
            (id: "eight_one_ultimate_", name: "Ultimate Solo"),
            (id: "eight_two_ultimate_", name: "Ultimate Doubles"),
            (id: "four_four_ultimate_", name: "Ultimate 4v4v4v4"),
            (id: "eight_two_lucky_", name: "Lucky Doubles"),
            (id: "four_four_lucky_", name: "Lucky 4v4v4v4"),
            (id: "eight_two_voidless_", name: "Voidless Doubles"),
            (id: "four_four_voidless_", name: "Voidless 4v4v4v4"),
            (id: "eight_two_armed_", name: "Armed Doubles"),
            (id: "four_four_armed_", name: "Armed 4v4v4v4"),
            (id: "castle_", name: "Castle"),
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D", "Final Kills", "Final Deaths", "Final K/D", "Current Winstreak", "Beds Broken", "Beds Lost"]
        
        var modeStats: [CellData] = []
        
        var dreamModesExist = false
        
        for (index, mode) in modes.enumerated() {
            
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data[mode.id + "wins_bedwars"].intValue
            var modeLosses = data[mode.id + "losses_bedwars"].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            if modeWins + modeLosses == 0 {
                if index < 5 {
                    modeCount -= 1
                } else {
                    dreamsModeCount -= 1
                }
                continue
            }
            
            var modeKills = data[mode.id + "kills_bedwars"].intValue
            var modeDeaths = data[mode.id + "deaths_bedwars"].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeFinalKills = data[mode.id + "final_kills_bedwars"].intValue
            var modeFinalDeaths = data[mode.id + "final_deaths_bedwars"].intValue
            var modeFinalKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)

            var modeWS = data[mode.id + "winstreak"].intValue
            
            var modeBedsBroken = data[mode.id + "beds_broken_bedwars"].intValue
            var modeBedsLost = data[mode.id + "beds_lost_bedwars"].intValue
            
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR, modeFinalKills, modeFinalDeaths, modeFinalKDR, modeWS, modeBedsBroken, modeBedsLost] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }
        
        ret.append(contentsOf: modeStats)
        
        var practiceModes = [
            (id: "bridging", name: "Bridging"),
            (id: "mlg", name: "MLG"),
            (id: "fireball_jumping", name: "Fireball/TNT Jumping"),
        ]
        
        var practiceModeStats: [CellData] = []
        
        for mode in practiceModes {
            var failedAttempts = data["practice"][mode.id]["failed_attempts"].intValue
            var successfulAttempts = data["practice"][mode.id]["successful_attempts"].intValue
            var blocksPlaced = data["practice"][mode.id]["blocks_placed"].intValue
            
            var percentSuccess = Utils.calculatePercentage(numerator: successfulAttempts, denominator: successfulAttempts + failedAttempts)
            
            var statsForThisMode: [(String, Any)] = [
                ("Successful Attempts", successfulAttempts),
                ("Failed Attempts", failedAttempts),
                ("Success Rate", percentSuccess),
                ("Blocks Placed", blocksPlaced)
            ]
            
            practiceModeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }
        
        ret.append(contentsOf: practiceModeStats)
        
        
        var bridgingElevations = [
            (id: "NONE", name: "Flat"),
            (id: "SLIGHT", name: "Inclined"),
            (id: "STAIRCASE", name: "Stairs")
        ]
        
        var bridgingAngles = [
            (id: "STRAIGHT", name: "Straight"),
            (id: "DIAGONAL", name: "Diagonal")
        ]
        
        var bridgingDistances = ["30", "50", "100"]
        
        var bridgingStats: [CellData] = []
        
        for angle in bridgingAngles {
            for elevation in bridgingElevations {
                var statsForThisMode: [(String, Any)] = []
                
                for distance in bridgingDistances {
                    var bestTime = data["practice"]["records"]["bridging_distance_" + distance + ":elevation_" + elevation.id + ":angle_" + angle.id].doubleValue
                    
                    var bestTimeString = bestTime == 0.0 ? "-" : String(format: "%.2fs", bestTime / 1000)
                    
                    statsForThisMode.append((distance + " Blocks", bestTimeString))
                }
                
                bridgingStats.append(CellData(headerData: (angle.name + " " + elevation.name, ""), sectionData: statsForThisMode))
            }
        }
        
        ret.append(contentsOf: bridgingStats)
        
        
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
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
        } else {
            category = statsTableData[indexPath.section].sectionData[indexPath.row - 1].0
            value = statsTableData[indexPath.section].sectionData[indexPath.row - 1].1
        }
        
        if value is Int {
            value = (value as! Int).withCommas
        }
        
        cell.configure(category: category, value: "\(value)")

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
        let headers = [
            2: "",
            5: "",
            6: "",
            12: "",
            14: "",
            20: "Modes"
        ]
        
        
        
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                return 32
            } else {
                return 64
            }
        }
        
        if section == 20 + modeCount || section == 20 + modeCount + dreamsModeCount || section == 20 + modeCount + dreamsModeCount + 3 {
            return 64
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headers = [
            2: "",
            5: "",
            6: "",
            12: "",
            14: "",
            20: "Modes"
        ]
        
        if modeCount == 0 && dreamsModeCount == 0 {
            headers[20] = "Practice Modes"
            headers[23] = "Bridging Personal Bests"
        } else if modeCount == 0 && dreamsModeCount != 0 {
            headers[20] = "Dream Modes"
            headers[20 + dreamsModeCount] = "Practice Modes"
            headers[20 + dreamsModeCount + 3] = "Bridging Personal Bests"
        } else if modeCount != 0 && dreamsModeCount == 0 {
            headers[20 + modeCount] = "Practice Modes"
            headers[20 + modeCount + 3] = "Bridging Personal Bests"
        } else {
            headers[20 + modeCount] = "Dream Modes"
            headers[20 + modeCount + dreamsModeCount] = "Practice Modes"
            headers[20 + modeCount + dreamsModeCount + 3] = "Bridging Personal Bests"
        }
        
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
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func getLevel(xp: Int) -> Double {
        let easyXP = [500.0, 1000.0, 2000.0, 3500.0]
        let normalXP = 5000.0
        
        var remainingXP = Double(xp)
        var lvl = 0
        var deltaXP = easyXP[0]
        
        while(remainingXP > 0) {
            deltaXP = normalXP
            if (lvl % 100 < 4) {
                deltaXP = easyXP[lvl % 100]
            }
            remainingXP -= Double(deltaXP)
            lvl += 1
        }
        
        return Double(lvl) + remainingXP / deltaXP
    }
    
    func getPrestige(level: Double) -> String {
        var prestiges = [
            (level: 0, colormap: "7", color: "gray", name: "None"),
            (level: 100, colormap: "f", color: "white", name: "Iron"),
            (level: 200, colormap: "6", color: "gold", name: "Gold"),
            (level: 300, colormap: "b", color: "aqua", name: "Diamond"),
            (level: 400, colormap: "2", color: "darkgreen", name: "Emerald"),
            (level: 500, colormap: "3", color: "darkaqua", name: "Sapphire"),
            (level: 600, colormap: "4", color: "darkred", name: "Ruby"),
            (level: 700, colormap: "d", color: "pink", name: "Crystal"),
            (level: 800, colormap: "9", color: "blue", name: "Opal"),
            (level: 900, colormap: "5", color: "purple", name: "Amethyst"),
            (level: 1000, colormap: "c6eabd5", color: "rainbow", name: "Rainbow"),
            (level: 1100, colormap: "7ffff77", color: "white", name: "Iron Prime"),
            (level: 1200, colormap: "7eeee67", color: "yellow", name: "Gold Prime"),
            (level: 1300, colormap: "7bbbb37", color: "aqua", name: "Diamond Prime"),
            (level: 1400, colormap: "7aaaa27", color: "green", name: "Emerald Prime"),
            (level: 1500, colormap: "7333397", color: "darkaqua", name: "Sapphire Prime"),
            (level: 1600, colormap: "7cccc47", color: "red", name: "Ruby Prime"),
            (level: 1700, colormap: "7dddd57", color: "pink", name: "Crystal Prime"),
            (level: 1800, colormap: "7999917", color: "blue", name: "Opal Prime"),
            (level: 1900, colormap: "7555587", color: "purple", name: "Amethyst Prime"),
            (level: 2000, colormap: "87ff778", color: "white", name: "Mirror"),
            (level: 2100, colormap: "ffee666", color: "yellow", name: "Light"),
            (level: 2200, colormap: "66ffb33", color: "aqua", name: "Dawn"),
            (level: 2300, colormap: "55dd6ee", color: "purple", name: "Dusk"),
            (level: 2400, colormap: "bbff778", color: "white", name: "Air"),
            (level: 2500, colormap: "ffaa222", color: "green", name: "Wind"),
            (level: 2600, colormap: "44ccdd5", color: "darkred", name: "Nebula"),
            (level: 2700, colormap: "eeff777", color: "yellow", name: "Thunder"),
            (level: 2800, colormap: "aa2266e", color: "darkgreen", name: "Earth"),
            (level: 2900, colormap: "bb33991", color: "blue", name: "Water"),
            (level: 3000, colormap: "ee66cc4", color: "red", name: "Fire"),
        ]
        
        var levelFloor = Int(floor(level))
        
        for prestige in prestiges.reversed() {
            if prestige.level <= levelFloor {
                return prestige.name
            }
        }
        
        return "None"
    }
    
    
}
