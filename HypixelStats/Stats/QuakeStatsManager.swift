//
//  QuakeStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/29/21.
//

import Foundation
import UIKit
import SwiftyJSON

class QuakeStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    lazy var statsTableData: [CellData] = {
        
        var winsSolo = data["wins"].intValue
        var winsTeams = data["wins_teams"].intValue
        var wins = winsSolo + winsTeams
        
        var killsSolo = data["kills"].intValue
        var killsTeams = data["kills_teams"].intValue
        var kills = killsSolo + killsTeams
        
        var deathsSolo = data["deaths"].intValue
        var deathsTeams = data["deaths_teams"].intValue
        var deaths = deathsSolo + deathsTeams
        
        var kdrSolo = GameTypes.calculateRatio(numerator: killsSolo, denominator: deathsSolo)
        var kdrTeams = GameTypes.calculateRatio(numerator: killsTeams, denominator: deathsTeams)
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        
        var headshotsSolo = data["headshots"].intValue
        var headshotsTeams = data["headshots_teams"].intValue
        var headshots = headshotsSolo + headshotsTeams
        
        var headshotsPerKillSolo = GameTypes.calculateRatio(numerator: headshotsSolo, denominator: deathsSolo)
        var headshotsPerKillTeams = GameTypes.calculateRatio(numerator: headshotsTeams, denominator: deathsTeams)
        var headshotsPerKill = GameTypes.calculateRatio(numerator: headshots, denominator: deaths)
        
        var shotsFiredSolo = data["shots_fired"].intValue
        var shotsFiredTeams = data["shots_fired_teams"].intValue
        var shotsFired = shotsFiredSolo + shotsFiredTeams
        
        var killsPerShotSolo = GameTypes.calculateRatio(numerator: killsSolo, denominator: shotsFiredSolo)
        var killsPerShotTeams = GameTypes.calculateRatio(numerator: killsTeams, denominator: shotsFiredTeams)
        var killsPerShot = GameTypes.calculateRatio(numerator: kills, denominator: shotsFired)
        
        var killstreaksSolo = data["killstreaks"].intValue
        var killstreaksTeams = data["killstreaks_teams"].intValue
        var killstreaks = killstreaksSolo + killstreaksTeams
        
        let statsSolo: [(String, Any)] = [
            ("Wins", winsSolo),
            ("Kills", killsSolo),
            ("Deaths", deathsSolo),
            ("K/D", kdrSolo),
            ("Killstreaks", killstreaksSolo),
            ("Headshots", headshotsSolo),
            ("Headshots/Kill", headshotsPerKillSolo),
            ("Kills/Shot", killsPerShotSolo)
        ]
        
        let statsTeams: [(String, Any)] = [
            ("Wins", winsTeams),
            ("Kills", killsTeams),
            ("Deaths", deathsTeams),
            ("K/D", kdrTeams),
            ("Killstreaks", killstreaksTeams),
            ("Headshots", headshotsTeams),
            ("Headshots/Kill", headshotsPerKillTeams),
            ("Kills/Shot", killsPerShotTeams)
        ]
        
        return [
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Killstreaks", killstreaks), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Headshots", headshots), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Shots Fired", shotsFired), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Headshots/Kill", headshotsPerKill), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills/Shot", killsPerShot), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Highest Killstreak", data["highest_killstreak"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Dash Cooldown", (data["dash_cooldown"].intValue) + 1), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Dash Power", (data["dash_power"].intValue) + 1), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Solo", ""), sectionData: statsSolo, isHeader: false, isOpened: false),
            
            CellData(headerData: ("Teams", ""), sectionData: statsTeams, isHeader: false, isOpened: false)
        ]
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
        
        let sectionsThatNeedHeader = [1, 5, 9, 10, 12, 13]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}