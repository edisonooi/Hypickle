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
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills (tap for details)", kills), sectionData: killsDivisions, isHeader: false, isOpened: false),
            CellData(headerData: ("Assists", data["assists"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false)
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
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode, isHeader: false, isOpened: false))
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
            
            var dataForThisMode = [kitWins, kitKills, kitAssists, kitDeaths, kitKDR] as [Any]
            
            for (index, category) in desiredKitStats.enumerated() {
                statsForThisKit.append((category, dataForThisMode[index]))
            }
            
            kitStats.append(CellData(headerData: (kit.name + " " + getKitLevel(kitID: kit.id), ""), sectionData: statsForThisKit, isHeader: false, isOpened: false))
            
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
        let sectionsThatNeedHeader = [3, 7, 11]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
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

