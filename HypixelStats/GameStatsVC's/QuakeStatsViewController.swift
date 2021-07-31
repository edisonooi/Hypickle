//
//  QuakeStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/29/21.
//

import Foundation
import UIKit
import SwiftyJSON

class QuakeStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Quakecraft"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var statsTableData: [CellData] = {
        
        var winsSolo = data["wins"].intValue ?? 0
        var winsTeams = data["wins_teams"].intValue ?? 0
        var wins = winsSolo + winsTeams
        
        var killsSolo = data["kills"].intValue ?? 0
        var killsTeams = data["kills_teams"].intValue ?? 0
        var kills = killsSolo + killsTeams
        
        var deathsSolo = data["deaths"].intValue ?? 0
        var deathsTeams = data["deaths_teams"].intValue ?? 0
        var deaths = deathsSolo + deathsTeams
        
        var kdrSolo = GameTypes.calculateKDR(kills: killsSolo, deaths: deathsSolo)
        var kdrTeams = GameTypes.calculateKDR(kills: killsTeams, deaths: deathsTeams)
        var kdr = GameTypes.calculateKDR(kills: kills, deaths: deaths)
        
        var headshotsSolo = data["headshots"].intValue ?? 0
        var headshotsTeams = data["headshots_teams"].intValue ?? 0
        var headshots = headshotsSolo + headshotsTeams
        
        var headshotsPerKillSolo = GameTypes.calculateKDR(kills: headshotsSolo, deaths: deathsSolo)
        var headshotsPerKillTeams = GameTypes.calculateKDR(kills: headshotsTeams, deaths: deathsTeams)
        var headshotsPerKill = GameTypes.calculateKDR(kills: headshots, deaths: deaths)
        
        var shotsFiredSolo = data["shots_fired"].intValue ?? 0
        var shotsFiredTeams = data["shots_fired_teams"].intValue ?? 0
        var shotsFired = shotsFiredSolo + shotsFiredTeams
        
        var killsPerShotSolo = GameTypes.calculateKDR(kills: killsSolo, deaths: shotsFiredSolo)
        var killsPerShotTeams = GameTypes.calculateKDR(kills: killsTeams, deaths: shotsFiredTeams)
        var killsPerShot = GameTypes.calculateKDR(kills: kills, deaths: shotsFired)
        
        var killstreaksSolo = data["killstreaks"].intValue ?? 0
        var killstreaksTeams = data["killstreaks_teams"].intValue ?? 0
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
            
            CellData(headerData: ("Highest Killstreak", data["highest_killstreak"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Dash Cooldown", (data["dash_cooldown"].intValue ?? 0) + 1), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Dash Power", (data["dash_power"].intValue ?? 0) + 1), sectionData: [], isHeader: false, isOpened: false),
            
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
        
        let sectionsThatNeedHeader = [9, 10, 12, 13]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
