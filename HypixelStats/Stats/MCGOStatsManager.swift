//
//  MCGOStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/15/21.
//

import Foundation
import UIKit
import SwiftyJSON

class MCGOStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var kills = getTotalStats(id: "kills")
        var deaths = getTotalStats(id: "deaths")
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var headshotKills = data["headshot_kills"].intValue
        var percentageHeadshot = Utils.calculatePercentage(numerator: headshotKills, denominator: kills)
        
        
        var generalStats = [
            
            CellData(headerData: ("Wins", getTotalStats(id: "game_wins")), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Round Wins", data["round_wins"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Assists", getTotalStats(id: "assists")), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Shots Fired", data["shots_fired"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Headshot Kills", headshotKills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Headshot Kill Percentage", percentageHeadshot), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Bombs Planted", data["bombs_planted"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Bombs Defused", data["bombs_defused"].intValue), sectionData: [], isHeader: false, isOpened: false)
            
        ]
        
        ret.append(contentsOf: generalStats)
        
        
        let modes = [
            (id: "", name: "Defusal"),
            (id: "_deathmatch", name: "Team Deathmatch")
        ]

        var desiredStats = ["Wins", "Kills", "Deaths", "K/D", "Cop Kills", "Criminal Kills"]

        var modeStats: [CellData] = []

        for mode in modes {
            var statsForThisMode: [(String, Any)] = []

            var modeWins = data["game_wins" + mode.id].intValue

            var modeKills = data["kills" + mode.id].intValue
            var modeDeaths = data["deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeCopKills = data["cop_kills" + mode.id].intValue
            var modeCrimKills = data["criminal_kills" + mode.id].intValue

            var dataForThisMode = [modeWins, modeKills, modeDeaths, modeKDR, modeCopKills, modeCrimKills] as [Any]

            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }

            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode, isHeader: false, isOpened: false))
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
        let sectionsThatNeedHeader = [2, 6, 9, 11]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func getTotalStats(id: String) -> Int {
        return data[id].intValue + data[id + "_deathmatch"].intValue
    }
}
