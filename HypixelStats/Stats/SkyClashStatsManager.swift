//
//  SkyClashStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/15/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SkyClashStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        7: "Modes",
        11: "Kits"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var killsDivisions = [
            ("Melee Kills", data["melee_kills"].intValue),
            ("Void Kills", data["void_kills"].intValue),
            ("Bow Kills", data["bow_kills"].intValue),
            ("Mob Kills", data["mob_kills"].intValue),
        ]
        
        var generalStats = [
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills (tap for details)", kills), sectionData: killsDivisions),
            CellData(headerData: ("Assists", data["assists"].intValue)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr))
        ]
        
        ret.append(contentsOf: generalStats)
        
        
        var modes = [
            (id: "solo", name: "Solo"),
            (id: "doubles", name: "Doubles"),
            (id: "team_war", name: "Team War"),
            (id: "mega", name: "Mega")
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins_" + mode.id].intValue
            var modeLosses = data["losses_" + mode.id].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills_" + mode.id].intValue
            var modeDeaths = data["deaths_" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }
        
        ret.append(contentsOf: modeStats)
        
        var kits = [
            (id: "_kit_archer", name: "Archer"),
            (id: "_kit_assassin", name: "Assassin"),
            (id: "_kit_berserker", name: "Berserker"),
            (id: "_kit_cleric", name: "Cleric"),
            (id: "_kit_frost_knight", name: "Frost Knight"),
            (id: "_kit_guardian", name: "Guardian"),
            (id: "_kit_jumpman", name: "Jumpman"),
            (id: "_kit_necromancer", name: "Necromancer"),
            (id: "_kit_scout", name: "Scout"),
            (id: "_kit_swordsman", name: "Swordsman"),
            (id: "_kit_treasure_hunter", name: "Treasure Hunter")
        ]
        
        var desiredKitStats = ["Wins", "Kills", "Assists", "Deaths", "K/D"]
        
        var kitStats: [CellData] = []
        
        for kit in kits {
            var statsForThisKit: [(String, Any)] = []
            
            var kitWins = 0
            
            for mode in modes {
                kitWins += data[mode.id + "_wins" + kit.id].intValue
            }
            
            var kitKills = data["kills" + kit.id].intValue
            var kitAssists = data["assists" + kit.id].intValue
            var kitDeaths = data["deaths" + kit.id].intValue
            var kitKDR = Utils.calculateRatio(numerator: kitKills, denominator: kitDeaths)
            
            if kitWins + kitDeaths == 0 {
                continue
            }
            
            var kitLevel = getKitLevel(kitID: kit.id)
            
            var color = UIColor.label
            
            if kitLevel == "VIII" {
                color = UIColor(named: "mc_gold")!
            }
            
            var dataForThisMode = [kitWins, kitKills, kitAssists, kitDeaths, kitKDR] as [Any]
            
            for (index, category) in desiredKitStats.enumerated() {
                statsForThisKit.append((category, dataForThisMode[index]))
            }
            
            kitStats.append(CellData(headerData: (kit.name + " " + kitLevel, ""), sectionData: statsForThisKit, color: color))
            
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
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
            
            if statsTableData[indexPath.section].color != .label {
                cell.statCategory.textColor = statsTableData[indexPath.section].color
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
    
    func getKitLevel(kitID: String) -> String {
        var level = 0
        
        var id = kitID
        id.remove(at: id.startIndex)
        
        level += data[id + "_minor"].intValue
        level += data[id + "_master"].intValue
        
        if level == 0 {
            return ""
        }
        
        return Utils.convertToRomanNumerals(number: level)
    }
}

