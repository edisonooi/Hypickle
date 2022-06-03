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
    
    let headers = [
        3: "",
        6: "",
        8: "",
        10: "",
        13: "",
        16: "Kits"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var assists = data["assists"].intValue
        var deaths = data["deaths"].intValue
        
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        var akr = Utils.calculateRatio(numerator: assists, denominator: kills)
        
        let winStats: [(String, Any)] = [
            ("Capture the Flag", data["wins_capturetheflag"].intValue),
            ("Domination", data["wins_domination"].intValue),
            ("Team Deathmatch", data["wins_teamdeathmatch"].intValue)
        ]
        
        var generalStats = [
            CellData(headerData: ("Wins", wins), sectionData: winStats),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", assists)),
            CellData(headerData: ("Deaths", deaths)),
            
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("Assists/Kill", akr)),
            
            CellData(headerData: ("Magic Dust", data["magic_dust"].intValue), sectionData: [], color: UIColor.MinecraftColors.aqua),
            CellData(headerData: ("Void Shards", data["void_shards"].intValue), sectionData: [], color: UIColor.MinecraftColors.lightPurple),
            
            CellData(headerData: ("Flags Captured CTF", data["flag_conquer_self"].intValue)),
            CellData(headerData: ("Flags Returned CTF", data["flag_returns"].intValue)),
            CellData(headerData: ("Points Captured Domination", data["dom_point_captures"].intValue)),
            
            CellData(headerData: ("Damage", data["damage"].intValue)),
            CellData(headerData: ("Damage Prevented", data["damage_prevented"].intValue)),
            CellData(headerData: ("Healing", data["heal"].intValue)),
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
            var kitWLR = Utils.calculateRatio(numerator: kitWins, denominator: kitLosses)
            
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
            
            var color = UIColor.label
            
            if kitLevel == 90 {
                color = UIColor.MinecraftColors.gold
            }
            
            kitStats.append(CellData(headerData: (kit.capitalized, "Lv\(kitLevel)"), sectionData: statsForThisKit, color: color))
            
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
}
