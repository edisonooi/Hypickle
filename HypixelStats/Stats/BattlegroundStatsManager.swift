//
//  BattlegroundStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/1/21.
//

import Foundation
import UIKit
import SwiftyJSON

class BattlegroundStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = GameTypes.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var assists = data["assists"].intValue
        var deaths = data["deaths"].intValue
        
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        var akr = GameTypes.calculateRatio(numerator: assists, denominator: kills)
        
        let winStats: [(String, Any)] = [
            ("Capture the Flag", data["wins_capturetheflag"].intValue),
            ("Domination", data["wins_domination"].intValue),
            ("Team Deathmatch", data["wins_teamdeathmatch"].intValue)
        ]
        
        var generalStats = [
            CellData(headerData: ("Wins (tap for details)", wins), sectionData: winStats, isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Assists", assists), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Assists/Kill", akr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Magic Dust", data["magic_dust"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Void Shards", data["void_shards"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Flags Captured CTF", data["flag_conquer_self"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Flags Returned CTF", data["flag_returns"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Points Captured Domination", data["dom_point_captures"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Damage", data["damage"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Damage Prevented", data["damage_prevented"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Healing", data["heal"].intValue), sectionData: [], isHeader: false, isOpened: false),
        ]

        ret.append(contentsOf: generalStats)

        
        let kits = ["mage", "paladin", "shaman", "warrior"]
        let upgrades = ["cooldown", "critchance", "critmultiplier", "energy", "health", "skill1", "skill2", "skill3", "skill4", "skill5"]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Damage", "Damage Prevented", "Healing"]
        
        var kitStats: [CellData] = []
        
        
        for kit in kits {
            var statsForThisKit: [(String, Any)] = []
            
            var kitWins = data["wins_" + kit].intValue
            var kitLosses = data["losses_" + kit].intValue
            var kitWLR = GameTypes.calculateRatio(numerator: kitWins, denominator: kitLosses)
            
            var kitDamage = data["damage_" + kit].intValue
            var kitDamagePrevented = data["damage_prevented_" + kit].intValue
            var kitHealing = data["heal_" + kit].intValue

                
            var dataForThisKit = [kitWins, kitLosses, kitWLR, kitDamage, kitDamagePrevented, kitHealing] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisKit.append((category, dataForThisKit[index]))
            }
            
            var kitLevel = 0
            
            for upgrade in upgrades {
                kitLevel += data[kit + "_" + upgrade].intValue
            }
            
            kitStats.append(CellData(headerData: (kit.capitalized, "Lv\(kitLevel)"), sectionData: statsForThisKit, isHeader: false, isOpened: false))
            
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
        let sectionsThatNeedHeader = [3, 6, 8, 10, 13, 16]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
