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
        var prestigeAndColors = getPrestige(level: level)
        
        
        var generalStats = [
            
            CellData(headerData: ("Level", String(format: "%.2f", level)), color: prestigeAndColors.levelColor),
            CellData(headerData: ("Prestige", prestigeAndColors.prestige), color: prestigeAndColors.prestigeColor),
            
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Current Winstreak", data["winstreak"].intValue)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("Final Kills", finalKills)),
            CellData(headerData: ("Final Deaths", finalDeaths)),
            CellData(headerData: ("Final K/D", finalKDR)),
            
            CellData(headerData: ("Beds Broken", data["beds_broken_bedwars"].intValue)),
            CellData(headerData: ("Beds Lost", data["beds_lost_bedwars"].intValue)),
            
            CellData(headerData: ("Iron Collected", data["iron_resources_collected_bedwars"].intValue)),
            CellData(headerData: ("Gold Collected", data["gold_resources_collected_bedwars"].intValue)),
            CellData(headerData: ("Diamonds Collected", data["diamond_resources_collected_bedwars"].intValue)),
            CellData(headerData: ("Emeralds Collected", data["emerald_resources_collected_bedwars"].intValue)),
            CellData(headerData: ("Wrapped Presents Collected", data["wrapped_present_resources_collected_bedwars"].intValue)),
            CellData(headerData: ("Shop Purchases", data["_items_purchased_bedwars"].intValue)),
            
            
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
            var modeFinalKDR = Utils.calculateRatio(numerator: modeFinalKills, denominator: modeFinalDeaths)

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
            if !statsTableData[indexPath.section].sectionData.isEmpty {
                cell.showDropDown()
            }
            
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
            
            if statsTableData[indexPath.section].color != .label {
                if statsTableData[indexPath.section].color == .clear {
                    let gradientImage = UIImage.gradientImageWithBounds(bounds: cell.statValue.bounds, colors: [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor])
                    cell.statValue.textColor = UIColor.init(patternImage: gradientImage)
                } else {
                    cell.statValue.textColor = statsTableData[indexPath.section].color
                }
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
    
    func getPrestige(level: Double) -> (prestige: String, levelColor: UIColor, prestigeColor: UIColor) {
        let prestiges = [
            (level: 0, levelColor: UIColor.MinecraftColors.gray, prestigeColor: UIColor.MinecraftColors.gray, name: "None"),
            (level: 100, levelColor: UIColor.MinecraftColors.white, prestigeColor: UIColor.MinecraftColors.white, name: "Iron"),
            (level: 200, levelColor: UIColor.MinecraftColors.gold, prestigeColor: UIColor.MinecraftColors.gold, name: "Gold"),
            (level: 300, levelColor: UIColor.MinecraftColors.aqua, prestigeColor: UIColor.MinecraftColors.aqua, name: "Diamond"),
            (level: 400, levelColor: UIColor.MinecraftColors.darkGreen, prestigeColor: UIColor.MinecraftColors.darkGreen, name: "Emerald"),
            (level: 500, levelColor: UIColor.MinecraftColors.darkAqua, prestigeColor: UIColor.MinecraftColors.darkAqua, name: "Sapphire"),
            (level: 600, levelColor: UIColor.MinecraftColors.darkRed, prestigeColor: UIColor.MinecraftColors.darkRed, name: "Ruby"),
            (level: 700, levelColor: UIColor.MinecraftColors.pink, prestigeColor: UIColor.MinecraftColors.pink, name: "Crystal"),
            (level: 800, levelColor: UIColor.MinecraftColors.blue, prestigeColor: UIColor.MinecraftColors.blue, name: "Opal"),
            (level: 900, levelColor: UIColor.MinecraftColors.darkPurple, prestigeColor: UIColor.MinecraftColors.darkPurple, name: "Amethyst"),
            //Clear means rainbow gradient
            (level: 1000, levelColor: .clear, prestigeColor: UIColor.MinecraftColors.gray, name: "Rainbow"),
            (level: 1100, levelColor: UIColor.MinecraftColors.white, prestigeColor: UIColor.MinecraftColors.gray, name: "Iron Prime"),
            (level: 1200, levelColor: UIColor.MinecraftColors.yellow, prestigeColor: UIColor.MinecraftColors.gray, name: "Gold Prime"),
            (level: 1300, levelColor: UIColor.MinecraftColors.aqua, prestigeColor: UIColor.MinecraftColors.gray, name: "Diamond Prime"),
            (level: 1400, levelColor: UIColor.MinecraftColors.green, prestigeColor: UIColor.MinecraftColors.gray, name: "Emerald Prime"),
            (level: 1500, levelColor: UIColor.MinecraftColors.darkAqua, prestigeColor: UIColor.MinecraftColors.gray, name: "Sapphire Prime"),
            (level: 1600, levelColor: UIColor.MinecraftColors.red, prestigeColor: UIColor.MinecraftColors.gray, name: "Ruby Prime"),
            (level: 1700, levelColor: UIColor.MinecraftColors.lightPurple, prestigeColor: UIColor.MinecraftColors.gray, name: "Crystal Prime"),
            (level: 1800, levelColor: UIColor.MinecraftColors.blue, prestigeColor: UIColor.MinecraftColors.gray, name: "Opal Prime"),
            (level: 1900, levelColor: UIColor.MinecraftColors.darkPurple, prestigeColor: UIColor.MinecraftColors.gray, name: "Amethyst Prime"),
            (level: 2000, levelColor: UIColor.MinecraftColors.gray, prestigeColor: UIColor.MinecraftColors.darkGray, name: "Mirror"),
            (level: 2100, levelColor: UIColor.MinecraftColors.gold, prestigeColor: UIColor.MinecraftColors.gold, name: "Light"),
            (level: 2200, levelColor: UIColor.MinecraftColors.darkAqua, prestigeColor: UIColor.MinecraftColors.darkAqua, name: "Dawn"),
            (level: 2300, levelColor: UIColor.MinecraftColors.yellow, prestigeColor: UIColor.MinecraftColors.yellow, name: "Dusk"),
            (level: 2400, levelColor: UIColor.MinecraftColors.darkGray, prestigeColor: UIColor.MinecraftColors.darkGray, name: "Air"),
            (level: 2500, levelColor: UIColor.MinecraftColors.darkGreen, prestigeColor: UIColor.MinecraftColors.darkGreen, name: "Wind"),
            (level: 2600, levelColor: UIColor.MinecraftColors.darkPurple, prestigeColor: UIColor.MinecraftColors.darkPurple, name: "Nebula"),
            (level: 2700, levelColor: UIColor.MinecraftColors.darkGray, prestigeColor: UIColor.MinecraftColors.darkGray, name: "Thunder"),
            (level: 2800, levelColor: UIColor.MinecraftColors.yellow, prestigeColor: UIColor.MinecraftColors.yellow, name: "Earth"),
            (level: 2900, levelColor: UIColor.MinecraftColors.darkBlue, prestigeColor: UIColor.MinecraftColors.darkBlue, name: "Water"),
            (level: 3000, levelColor: UIColor.MinecraftColors.darkRed, prestigeColor: UIColor.MinecraftColors.darkRed, name: "Fire"),
        ]
        
        let levelFloor = Int(floor(level))
        
        for prestige in prestiges.reversed() {
            if prestige.level <= levelFloor {
                return (prestige: prestige.name, levelColor: prestige.levelColor, prestigeColor: prestige.prestigeColor)
            }
        }
        
        return (prestige: "None", levelColor: UIColor.MinecraftColors.gray, prestigeColor: UIColor.MinecraftColors.gray)
    }
    
    
}
