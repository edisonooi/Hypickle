//
//  SpeedUHCStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/5/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SpeedUHCStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Speed UHC"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue ?? 0
        var losses = data["losses"].intValue ?? 0
        var wlr = GameTypes.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue ?? 0
        var deaths = data["deaths"].intValue ?? 0
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        
        var titleAndStar = getTitleAndStar(score: data["score"].intValue ?? 0)
        
        var generalStats = [
            
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Score", data["score"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Title", titleAndStar.0), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Best Overall Winstreak", data["highestWinstreak"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Current Winstreak", data["winstreak"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false)

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
            
            var modeWins = data["wins" + mode.id].intValue ?? 0
            var modeLosses = data["losses" + mode.id].intValue ?? 0
            var modeWLR = GameTypes.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills" + mode.id].intValue ?? 0
            var modeDeaths = data["deaths" + mode.id].intValue ?? 0
            var modeKDR = GameTypes.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
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
        let cell = statsTable.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
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
            statsTable.reloadSections(sections, with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionsThatNeedHeader = [3, 6, 8, 10]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
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
