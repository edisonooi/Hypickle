//
//  MurderMysteryStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/6/21.
//

import Foundation
import UIKit
import SwiftyJSON

class MurderMysteryStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    var achievementsData: JSON = [:]
    
    init(data: JSON, achievementsData: JSON) {
        self.data = data
        self.achievementsData = achievementsData
    }
    
    let headers = [
        3: "",
        6: "",
        8: "",
        10: "Modes"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = (data["games"].intValue) - wins
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var fastestMurdWin = data["quickest_murderer_win_time_seconds"].intValue
        var fastestDetWin = data["quickest_detective_win_time_seconds"].intValue
        
        var murdWinString = fastestMurdWin == 0 ? "N/A" : Utils.formatMinuteSeconds(totalSeconds: fastestMurdWin)
        var detWinString = fastestDetWin == 0 ? "N/A" : Utils.formatMinuteSeconds(totalSeconds: fastestDetWin)
        
        let winsDivisions = [
            ("Murderer Wins", data["murderer_wins"].intValue),
            ("Detective Wins", data["detective_wins"].intValue),
            ("Hero Wins", data["was_hero"].intValue)
        ]
        
        let killsDivisions = [
            ("Kills as Murderer", data["kills_as_murderer"].intValue),
            ("Thrown Knife Kills", data["thrown_knife_kills"].intValue),
            ("Bow Kills", data["bow_kills"].intValue)
        ]
        
        let knifeSkins = [
            "knife_skin_bone" : "Big Bone",
            "knife_skin_blaze_stick" : "Blaze Rod",
            "knife_skin_carrot_on_stick" : "Carrot on a Stick",
            "knife_skin_cheapo" : "Cheapo Sword",
            "knife_skin_cheese" : "Cheese",
            "knife_skin_chewed_bush" : "Chewed Up Bush",
            "knife_skin_diamond_shovel" : "Only the Best",
            "knife_skin_easter_basket" : "Easter Basket",
            "knife_skin_feather" : "Jagged",
            "knife_skin_jagged" : "Jagged",
            "knife_skin_glistening_melon" : "Glistening Melon",
            "knife_skin_gold_digger" : "Gold Digger",
            "knife_skin_apple" : "Healthy Treat",
            "knife_skin_ice_shard" : "Ice Shard",
            "undefined" : "Default Iron Sword",
            "knife_skin_mouse_trap" : "Mouse Trap",
            "knife_skin_mvp" : "MVP Diamond Sword",
            "knife_skin_none" : "Iron Sword",
            "knife_skin_prickly" : "Prickly",
            "knife_skin_pumpkin_pie" : "Pumpkin Pie",
            "random_cosmetic" : "Random",
            "knife_skin_scythe" : "Reaper Scythe",
            "knife_skin_rudolphs_snack" : "Rudolph's Favourite Snack",
            "knife_skin_rudolphs_nose" : "Rudolph's Nose",
            "knife_skin_salmon" : "Salmon",
            "knife_skin_shears" : "Shears",
            "knife_skin_shovel" : "Shovel",
            "knife_skin_shiny_snack" : "Sparkly Snack",
            "knife_skin_stake" : "Stake",
            "knife_skin_stick" : "Stick",
            "knife_skin_stick_with_hat" : "Stick with a Hat",
            "knife_skin_sweet_treat" : "Sweet Treat",
            "knife_skin_timber" : "Timber",
            "knife_skin_vip" : "VIP Gold Sword",
            "knife_skin_wood_axe" : "Wood Axe"
        ]
        
        var generalStats = [
            
            CellData(headerData: ("Wins", wins), sectionData: winsDivisions),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills), sectionData: killsDivisions),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Fastest Murderer Win", murdWinString)),
            CellData(headerData: ("Fastest Detective Win", detWinString)),
            
            CellData(headerData: ("Murder Weapon", knifeSkins[data["active_knife_skin"].stringValue] ?? "Default Iron Sword"), sectionData: [], color: UIColor.MinecraftColors.darkRed),
            CellData(headerData: ("Gold Picked Up", data["coins_pickedup"].intValue), sectionData: [], color: UIColor.MinecraftColors.gold)
        ]
        
        ret.append(contentsOf: generalStats)
        
        var modes = [
           (id: "_MURDER_CLASSIC", name: "Classic"),
           (id: "_MURDER_ASSASSINS", name: "Assassins"),
           (id: "_MURDER_DOUBLE_UP", name: "Double Up"),
           (id: "_MURDER_INFECTION", name: "Infection"),
           (id: "_MURDER_HARDCORE", name: "Hardcore"),
           (id: "_MURDER_SHOWDOWN", name: "Showdown")
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Knife Kills", "Thrown Knife Kills", "Bow Kills", "Deaths", "K/D", "Gold Picked Up"]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            
            if mode.id == "_MURDER_HARDCORE" && (data["games" + mode.id].exists() || data["games_MURDER_SHOWDOWN"].exists()) {
                modeStats.append(CellData(headerData: ("Legacy Modes", "")))
            }
            
            if !data["games" + mode.id].exists() {
                continue
            }
            
            var statsForThisMode: [(String, Any)] = []
            
            if mode.id == "_MURDER_INFECTION" {
                var infectionDesiredStats = ["Wins", "Wins as Survivor", "Kills as Infected", "Kills as Survivor", "Final Kills", "Total Time Survived", "Gold Pickups"]
                
                var wins = data["wins" + mode.id].intValue
                var survivorWins = achievementsData["murdermystery_survival_skills"].intValue
                
                var killsAsInfected = data["kills_as_infected" + mode.id].intValue
                var killsAsSurvivor = data["kills_as_survivor" + mode.id].intValue
                var finalKills = data["kills" + mode.id].intValue
                
                var timeSurvived = Utils.convertToHoursMinutesSeconds(seconds: data["total_time_survived_seconds" + mode.id].intValue)
                
                var infectionGoldPickups = data["coins_pickedup" + mode.id].intValue
                
                var infectionData = [wins, survivorWins, killsAsInfected, killsAsSurvivor, finalKills, timeSurvived, infectionGoldPickups] as [Any]
                
                for (index, category) in infectionDesiredStats.enumerated() {
                    statsForThisMode.append((category, infectionData[index]))
                }
                
                modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
                
                continue
            }
            
            var modeWins = data["wins" + mode.id].intValue
            var modeLosses = (data["games" + mode.id].intValue) - modeWins
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills" + mode.id].intValue
            var modeDeaths = data["deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeKnifeKills = data["knife_kills" + mode.id].intValue
            var modeThrownKnifeKills = data["thrown_knife_kills" + mode.id].intValue
            var modeBowKills = data["bow_kills" + mode.id].intValue
            
            var modeGoldPickups = data["coins_pickedup" + mode.id].intValue
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeKnifeKills, modeThrownKnifeKills, modeBowKills, modeDeaths, modeKDR, modeGoldPickups] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }
        
        ret.append(contentsOf: modeStats)
        
        
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
            
            if category == "Legacy Modes" {
                cell.backgroundColor = .clear
                cell.statCategory.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            if statsTableData[indexPath.section].color != .label {
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
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
