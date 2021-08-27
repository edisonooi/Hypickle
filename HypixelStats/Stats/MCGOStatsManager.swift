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
    
    let headers = [
        2: "",
        6: "",
        9: "",
        11: "Modes"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var kills = getTotalStats(id: "kills")
        var deaths = getTotalStats(id: "deaths")
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var headshotKills = data["headshot_kills"].intValue
        var percentageHeadshot = Utils.calculatePercentage(numerator: headshotKills, denominator: kills)
        
        
        var generalStats = [
            
            CellData(headerData: ("Wins", getTotalStats(id: "game_wins"))),
            CellData(headerData: ("Round Wins", data["round_wins"].intValue)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", getTotalStats(id: "assists"))),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Shots Fired", data["shots_fired"].intValue)),
            CellData(headerData: ("Headshot Kills", headshotKills)),
            CellData(headerData: ("Headshot Kill Percentage", percentageHeadshot)),
            
            CellData(headerData: ("Bombs Planted", data["bombs_planted"].intValue)),
            CellData(headerData: ("Bombs Defused", data["bombs_defused"].intValue))
            
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
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
            
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
    
    func getTotalStats(id: String) -> Int {
        return data[id].intValue + data[id + "_deathmatch"].intValue
    }
}
