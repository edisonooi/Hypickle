//
//  TrueCombatStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/15/21.
//

import Foundation
import UIKit
import SwiftyJSON

class TrueCombatStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        6: "",
        9: "Modes"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var arrowsShot = data["arrows_shot"].intValue
        var arrowsHit = data["arrows_hit"].intValue
        var arrowAccuracy = Utils.calculatePercentage(numerator: arrowsHit, denominator: arrowsShot)
        
        
        var generalStats = [

            CellData(headerData: ("Wins", wins), sectionData: []),
            CellData(headerData: ("Losses", losses), sectionData: []),
            CellData(headerData: ("W/L", wlr), sectionData: []),
            
            CellData(headerData: ("Kills", kills), sectionData: []),
            CellData(headerData: ("Deaths", deaths), sectionData: []),
            CellData(headerData: ("K/D", kdr), sectionData: []),
            
            CellData(headerData: ("Arrows Shot", arrowsShot), sectionData: []),
            CellData(headerData: ("Arrows Hit", arrowsHit), sectionData: []),
            CellData(headerData: ("Arrow Accuracy", arrowAccuracy), sectionData: [])
        ]
        
        ret.append(contentsOf: generalStats)
        
        let modes = [
            (id: "_solo",  name: "Solo Normal"),
            (id: "_solo_chaos",  name: "Solo Lucky"),
            (id: "_team",  name: "Teams Normal"),
            (id: "_team_chaos",  name: "Teams Lucky"),
        ]

        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]

        var modeStats: [CellData] = []

        for mode in modes {
            var statsForThisMode: [(String, Any)] = []

            var modeWins = data["crazywalls_wins" + mode.id].intValue
            var modeLosses = data["crazywalls_losses" + mode.id].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            if modeWins + modeLosses == 0 {
                continue
            }

            var modeKills = data["crazywalls_kills" + mode.id].intValue
            var modeDeaths = data["crazywalls_deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)

            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]

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
