//
//  PitStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/15/21.
//

import Foundation
import UIKit
import SwiftyJSON

class PitStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [4: "", 6: "", 12: "", 17: "", 19: "", 22: "", 25: "", 27: "", 31: "", 35: ""]
    
    lazy var statsTableData: [CellData] = {
        
        let stats = data["pit_stats_ptl"]
        let profile = data["profile"]
        
        var xp = profile["xp"].intValue
        var prestigeAndLevel = getPrestigeAndLevel(playerXP: xp)
        var prestigeString = prestigeAndLevel.0 == 0 ? "-" : Utils.convertToRomanNumerals(number: prestigeAndLevel.0)
        
        var kills = stats["kills"].intValue
        var assists = stats["assists"].intValue
        var deaths = stats["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        var kadr = Utils.calculateRatio(numerator: kills + assists, denominator: deaths)
        
        var playtimeMinutes = stats["playtime_minutes"].intValue
        var playtimeHours = Double(playtimeMinutes) / 60.0
        
        var kaPerHour = calculateStatsPerHour(numerator: Double(kills + assists), denominator: playtimeHours)
        var killsPerHour = calculateStatsPerHour(numerator: Double(kills), denominator: playtimeHours)
        var goldPerHour = calculateStatsPerHour(numerator: stats["cash_earned"].doubleValue, denominator: playtimeHours)
        var xpPerHour = calculateStatsPerHour(numerator: Double(xp), denominator: playtimeHours)
        
        return [
            CellData(headerData: ("Prestige", prestigeString), color: getPrestigeColor(prestige: prestigeAndLevel.0)),
            CellData(headerData: ("Level", prestigeAndLevel.1), color: getLevelColor(level: prestigeAndLevel.1)),
            CellData(headerData: ("XP", xp), sectionData: [], color: UIColor.MinecraftColors.aqua),
            CellData(headerData: ("Renown", profile["renown"].intValue), sectionData: [], color: UIColor.MinecraftColors.yellow),
            
            CellData(headerData: ("Current Gold", Int(floor(profile["cash"].doubleValue))), sectionData: [], color: UIColor.MinecraftColors.gold),
            CellData(headerData: ("Lifetime Gold", stats["cash_earned"].intValue), sectionData: [], color: UIColor.MinecraftColors.gold),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", assists)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("KA/D", kadr)),
            CellData(headerData: ("Highest Killstreak", stats["max_streak"].intValue)),
            
            CellData(headerData: ("Playtime", Utils.convertToHoursMinutesSeconds(seconds: playtimeMinutes * 60))),
            CellData(headerData: ("Kills/Hour", String(format: "%.2f", killsPerHour))),
            CellData(headerData: ("KA/Hour", String(format: "%.2f", kaPerHour))),
            CellData(headerData: ("XP/Hour", String(format: "%.2f", xpPerHour)), sectionData: [], color: UIColor.MinecraftColors.aqua),
            CellData(headerData: ("Gold/Hour", String(format: "%.2f", goldPerHour)), sectionData: [], color: UIColor.MinecraftColors.gold),
            
            CellData(headerData: ("Jumps into Pit", stats["jumped_into_pit"].intValue)),
            CellData(headerData: ("Launcher Launches", stats["launched_by_launchers"].intValue)),
            
            CellData(headerData: ("Contracts Completed", stats["contracts_completed"].intValue)),
            CellData(headerData: ("Night Quests Completed", stats["night_quests_completed"].intValue)),
            CellData(headerData: ("King's Quest Completions", stats["king_quest_completion"].intValue)),
            
            CellData(headerData: ("Tier 1 Mystics Enchanted", stats["enchanted_tier1"].intValue)),
            CellData(headerData: ("Tier 2 Mystics Enchanted", stats["enchanted_tier2"].intValue)),
            CellData(headerData: ("Tier 3 Mystics Enchanted", stats["enchanted_tier3"].intValue)),
            
            CellData(headerData: ("Wheat Farmed", stats["wheat_farmed"].intValue)),
            CellData(headerData: ("Diamond Items Purchased", stats["diamond_items_purchased"].intValue)),
            
            CellData(headerData: ("Golden Heads Eaten", stats["ghead_eaten"].intValue)),
            CellData(headerData: ("Golden Apples Eaten", stats["gapple_eaten"].intValue)),
            CellData(headerData: ("Soups Drank", stats["soups_drank"].intValue)),
            CellData(headerData: ("Rage Potatoes Eaten", stats["rage_potatoes_eaten"].intValue)),
            
            CellData(headerData: ("Lava Buckets Emptied", stats["lava_bucket_emptied"].intValue)),
            CellData(headerData: ("Fishing Rods Launched", stats["fishing_rod_launched"].intValue)),
            CellData(headerData: ("Items Fished", stats["fished_anything"].intValue)),
            CellData(headerData: ("Fish Fished", stats["fishes_fished"].intValue)),
            
            CellData(headerData: ("Blocks Placed", stats["blocks_placed"].intValue)),
            CellData(headerData: ("Blocks Broken", stats["blocks_broken"].intValue)),
            CellData(headerData: ("Obsidian Broken", stats["obsidian_broken"].intValue))
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
    
    func getPrestigeAndLevel(playerXP: Int) -> (Int, Int) {
        
        let xpLevels = [
            [15,   30,   50,   75,   125,   300,   600,   800,   900,   1000,   1200,   1500],
            [17,   33,   55,   83,   138,   330,   660,   880,   990,   1100,   1320,   1650],
            [18,   36,   61,   91,   151,   360,   720,   960,   1080,  1200,   1440,   1800],
            [19,   38,   64,   99,   165,   390,   780,   1040,  1170,  1300,   1560,   1950],
            [21,   42,   70,   105,  175,   420,   840,   1120,  1260,  1400,   1680,   2100],
            [22,   44,   74,   114,  190,   450,   900,   1200,  1350,  1500,   1800,   2250],
            [27,   55,   88,   131,  218,   525,   1050,  1400,  1575,  1750,   2100,   2625],
            [30,   60,   100,  150,  250,   600,   1200,  1600,  1800,  2000,   2400,   3000],
            [38,   75,   125,  188,  313,   750,   1500,  2000,  2250,  2500,   3000,   3750],
            [45,   90,   150,  225,  375,   900,   1800,  2400,  2700,  3000,   3600,   4500],
            [60,   120,  200,  300,  500,   1200,  2400,  3200,  3600,  4000,   4800,   6000],
            [75,   150,  250,  375,  625,   1500,  3000,  4000,  4500,  5000,   6000,   7500],
            [90,   180,  300,  450,  750,   1800,  3600,  4800,  5400,  6000,   7200,   9000],
            [105,  210,  350,  525,  875,   2100,  4200,  5600,  6300,  7000,   8400,   10500],
            [120,  240,  400,  600,  1000,  2400,  4800,  6400,  7200,  8000,   9600,   12000],
            [135,  270,  450,  675,  1125,  2700,  5400,  7200,  8100,  9000,   10800,  13500],
            [150,  300,  500,  750,  1250,  3000,  6000,  8000,  9000,  10000,  12000,  15000],
            [180,  360,  600,  900,  1500,  3600,  7200,  9600,  10800, 12000,  14400,  18000],
            [210,  420,  700,  1050, 1750,  4200,  8400,  11200, 12600, 14000,  16800,  21000],
            [240,  480,  800,  1200, 2000,  4800,  9600,  12800, 14400, 16000,  19200,  24000],
            [270,  540,  900,  1350, 2250,  5400,  10800, 14400, 16200, 18000,  21600,  27000],
            [300,  600,  1000, 1500, 2500,  6000,  12000, 16000, 18000, 20000,  24000,  30000],
            [360,  720,  1200, 1800, 3000,  7200,  14400, 19200, 21600, 24000,  28800,  36000],
            [420,  840,  1400, 2100, 3500,  8400,  16800, 22400, 25200, 28000,  33600,  42000],
            [480,  960,  1600, 2400, 4000,  9600,  19200, 25600, 28800, 32000,  38400,  48000],
            [540,  1080, 1800, 2700, 4500,  10800, 21600, 28800, 32400, 36000,  43200,  54000],
            [600,  1200, 2000, 3000, 5000,  12000, 24000, 32000, 36000, 40000,  48000,  60000],
            [675,  1350, 2250, 3375, 5625,  13500, 27000, 36000, 40500, 45000,  54000,  67500],
            [750,  1500, 2500, 3750, 6250,  15000, 30000, 40000, 45000, 50000,  60000,  75000],
            [1125, 2250, 3750, 5625, 9375,  22500, 45000, 60000, 67500, 75000,  90000,  112500],
            [1500, 3000, 5000, 7500, 12500, 30000, 60000, 80000, 90000, 100000, 120000, 150000],
            [1515, 3030, 5050, 7575, 12625, 30300, 60600, 80800, 90900, 101000, 121200, 151500],
            [1515, 3030, 5050, 7575, 12625, 30300, 60600, 80800, 90900, 101000, 121200, 151500],
            [1515, 3030, 5050, 7575, 12625, 30300, 60600, 80800, 90900, 101000, 121200, 151500],
            [1515, 3030, 5050, 7575, 12625, 30300, 60600, 80800, 90900, 101000, 121200, 151500],
            [1515, 3030, 5050, 7575, 12625, 30300, 60600, 80800, 90900, 101000, 121200, 151500],
        ]
        
        
        
        let maxPrestige = 35
        let maxLevel = 120
        
        var xp = playerXP
        
        for i in 0..<xpLevels.count {
            for j in 0..<xpLevels[i].count {
                for k in 0...9 {
                    let step = xpLevels[i][j]
                    
                    if xp >= step {
                        xp -= step
                    } else {
                        return (i, 10 * j + k)
                    }
                }
            }
        }
        
        return (maxPrestige, maxLevel)
    }
    
    func calculateStatsPerHour(numerator: Double, denominator: Double) -> Double {
        var ratio = 0.0
        
        if numerator == 0.0 && denominator == 0.0 {
            ratio = 0.0
        } else if numerator != 0.0 && denominator == 0.0 {
            ratio = numerator
        } else {
            ratio = numerator / denominator
        }
        
        return ratio
    }
    
    func getPrestigeColor(prestige: Int) -> UIColor {

        let prestigeColors = [
            (prestige: 0, color: UIColor.MinecraftColors.gray),
            (prestige: 1, color: UIColor.MinecraftColors.blue),
            (prestige: 5, color: UIColor.MinecraftColors.yellow),
            (prestige: 10, color: UIColor.MinecraftColors.gold),
            (prestige: 15, color: UIColor.MinecraftColors.red),
            (prestige: 20, color: UIColor.MinecraftColors.darkPurple),
            (prestige: 25, color: UIColor.MinecraftColors.lightPurple),
            (prestige: 30, color: UIColor.MinecraftColors.white),
            (prestige: 35, color: UIColor.MinecraftColors.aqua),
        ]
        
        for p in prestigeColors.reversed() {
            if p.prestige <= prestige {
                return p.color
            }
        }
        
        return UIColor.MinecraftColors.gray
    }
    
    func getLevelColor(level: Int) -> UIColor {
        
        let levelColors = [
            (level: 0, color: UIColor.MinecraftColors.gray),
            (level: 10, color: UIColor.MinecraftColors.blue),
            (level: 20, color: UIColor.MinecraftColors.darkAqua),
            (level: 30, color: UIColor.MinecraftColors.darkGreen),
            (level: 40, color: UIColor.MinecraftColors.green),
            (level: 50, color: UIColor.MinecraftColors.yellow),
            (level: 60, color: UIColor.MinecraftColors.gold),
            (level: 70, color: UIColor.MinecraftColors.red),
            (level: 80, color: UIColor.MinecraftColors.darkRed),
            (level: 90, color: UIColor.MinecraftColors.darkPurple),
            (level: 100, color: UIColor.MinecraftColors.lightPurple),
            (level: 110, color: UIColor.MinecraftColors.white),
            (level: 120, color: UIColor.MinecraftColors.aqua),
        ]
        
        for l in levelColors.reversed() {
            if l.level <= level {
                return l.color
            }
        }
        
        return UIColor.MinecraftColors.gray
    }
    
}
