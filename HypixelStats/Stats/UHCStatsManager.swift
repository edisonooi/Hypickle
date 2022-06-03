//
//  UHCStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/6/21.
//

import Foundation
import UIKit
import SwiftyJSON

class UHCStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        1: "",
        4: "",
        7: "",
        9: "Modes"
    ]
    
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = 0, kills = 0, deaths = 0, headsEaten = 0

        var modes = [
            (id: "_solo", name: "Solo"),
            (id: "", name: "Teams"),
            (id: "_red vs blue", name: "Red vs. Blue"),
            (id: "_no diamonds", name: "No Diamonds"),
            (id: "_vanilla doubles", name: "Vanilla Doubles"),
            (id: "_brawl", name: "Brawl"),
            (id: "_solo brawl", name: "Solo Brawl"),
            (id: "_duo brawl", name: "Duo Brawl"),
        ]
        
        var desiredStats = ["Wins", "Kills", "Deaths", "K/D", "Kills/Wins", "Heads Eaten"]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins" + mode.id].intValue
            
            var modeKills = data["kills" + mode.id].intValue
            var modeDeaths = data["deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeKW = Utils.calculateRatio(numerator: modeKills, denominator: modeWins)
            var modeHeadsEaten = data["heads_eaten" + mode.id].intValue
            
            wins += modeWins
            kills += modeKills
            deaths += modeDeaths
            headsEaten += modeHeadsEaten
            
            if modeWins + modeKills + modeDeaths == 0 {
                continue
            }
            
            var dataForThisMode = [modeWins, modeKills, modeDeaths, modeKDR, modeKW, modeHeadsEaten] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }
        
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var titleAndStar = getTitleAndStar(score: data["score"].intValue)
        
        var generalStats = [
            
            CellData(headerData: ("Wins", wins)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Score", data["score"].intValue)),
            CellData(headerData: ("Stars", String(titleAndStar.1) + "\u{2606}"), color: UIColor.MinecraftColors.gold),
            CellData(headerData: ("Title", titleAndStar.0), color: titleAndStar.2),
            
            CellData(headerData: ("Heads Eaten", headsEaten)),
            CellData(headerData: ("Ultimates Crafted", (data["ultimates_crafted"].intValue) + (data["ultimates_crafted_solo"].intValue))),

        ]
        
        
        ret.append(contentsOf: generalStats)
        
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
    
    func getTitleAndStar(score: Int) -> (String, Int, UIColor) {
        let titles = [
            (value: 0, name: "Recruit", color: .label),
            (value: 10, name: "Initiate", color: .label),
            (value: 60, name: "Soldier", color: .label),
            (value: 210, name: "Sergeant", color: .label),
            (value: 460, name: "Knight", color: .label),
            (value: 960, name: "Captain", color: .label),
            (value: 1710, name: "Centurion", color: .label),
            (value: 2710, name: "Gladiator", color: .label),
            (value: 5210, name: "Warlord", color: .label),
            (value: 10210, name: "Champion", color: .label),
            (value: 13210, name: "Champion", color: .label),
            (value: 16210, name: "Bronze Champion", color: UIColor.MinecraftColors.bronze),
            (value: 19210, name: "Silver Champion", color: UIColor.MinecraftColors.white),
            (value: 22210, name: "Gold Champion", color: UIColor.MinecraftColors.gold),
            (value: 25210, name: "High Champion", color: UIColor.MinecraftColors.aqua),
            (value: Int.max, name: nil, color: nil)
        ]
        
        for (index, title) in titles.enumerated() {
            if score < title.value {
                return (titles[index - 1].name!, index, titles[index - 1].color!)
            }
        }
        
        return ("Recruit", 1, .label)
    }
    
    
}
