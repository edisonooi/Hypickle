//
//  SpeedUHCStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/5/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SpeedUHCStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        6: "",
        9: "",
        11: "Modes"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var titleAndStar = getTitleAndStar(score: data["score"].intValue)
        
        var generalStats = [
            
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Score", data["score"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Stars", titleAndStar.1), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Title", titleAndStar.0), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Best Overall Winstreak", data["highestWinstreak"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Current Winstreak", data["winstreak"].intValue), sectionData: [], isHeader: false, isOpened: false)

        ]
        
        ret.append(contentsOf: generalStats)
        
        var modes = [
            (id: "_solo_normal", name: "Solo Normal"),
            (id: "_solo_insane", name: "Solo Insane"),
            (id: "_team_normal", name: "Teams Normal"),
            (id: "_team_insane", name: "Teams Insane")
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins" + mode.id].intValue
            var modeLosses = data["losses" + mode.id].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills" + mode.id].intValue
            var modeDeaths = data["deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            if modeWins + modeDeaths == 0 {
                continue
            }
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
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
    
    func getTitleAndStar(score: Int) -> (String, Int) {
        let titles = [
            (value: 0, name: "Hiker"),
            (value: 50, name: "Jogger"),
            (value: 300, name: "Runner"),
            (value: 1050, name: "Sprinter"),
            (value: 2560, name: "Turbo"),
            (value: 5550, name: "Sanic"),
            (value: 15550, name: "Hot Rod"),
            (value: 30550, name: "Bolt"),
            (value: 55550, name: "Zoom"),
            (value: 85550, name: "God Speed"),
            (value: Int.max, name: nil)
        ]
        
        for (index, title) in titles.enumerated() {
            if score < title.value {
                return (titles[index - 1].name!, index)
            }
        }
        
        return ("Hiker", 1)
    }
    
    
}
