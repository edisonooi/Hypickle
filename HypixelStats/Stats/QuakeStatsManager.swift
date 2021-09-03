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
    var achievementsData: JSON = [:]
    
    init(data: JSON, achievementsData: JSON) {
        self.data = data
        self.achievementsData = achievementsData
    }
    
    let headers = [
        1: "",
        6: "",
        10: "",
        11: "",
        13: "Modes"
    ]
    
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
        
        var kdrSolo = Utils.calculateRatio(numerator: killsSolo, denominator: deathsSolo)
        var kdrTeams = Utils.calculateRatio(numerator: killsTeams, denominator: deathsTeams)
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var headshotsSolo = data["headshots"].intValue
        var headshotsTeams = data["headshots_teams"].intValue
        var headshots = headshotsSolo + headshotsTeams
        
        var headshotsPerKillSolo = Utils.calculateRatio(numerator: headshotsSolo, denominator: deathsSolo)
        var headshotsPerKillTeams = Utils.calculateRatio(numerator: headshotsTeams, denominator: deathsTeams)
        var headshotsPerKill = Utils.calculateRatio(numerator: headshots, denominator: deaths)
        
        var shotsFiredSolo = data["shots_fired"].intValue
        var shotsFiredTeams = data["shots_fired_teams"].intValue
        var shotsFired = shotsFiredSolo + shotsFiredTeams
        
        var killsPerShotSolo = Utils.calculateRatio(numerator: killsSolo, denominator: shotsFiredSolo)
        var killsPerShotTeams = Utils.calculateRatio(numerator: killsTeams, denominator: shotsFiredTeams)
        var killsPerShot = Utils.calculateRatio(numerator: kills, denominator: shotsFired)
        
        var killstreaksSolo = data["killstreaks"].intValue
        var killstreaksTeams = data["killstreaks_teams"].intValue
        var killstreaks = killstreaksSolo + killstreaksTeams
        
        var godlikes = achievementsData["quake_godlikes"].intValue
        var godlikeColor = godlikes == 0 ? UIColor.label : UIColor(named: "mc_gold")!
        
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
            CellData(headerData: ("Wins", wins)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("Killstreaks", killstreaks)),
            CellData(headerData: ("Godlikes", godlikes), color: godlikeColor),
            
            CellData(headerData: ("Headshots", headshots)),
            CellData(headerData: ("Shots Fired", shotsFired)),
            CellData(headerData: ("Headshots/Kill", headshotsPerKill)),
            CellData(headerData: ("Kills/Shot", killsPerShot)),
            
            CellData(headerData: ("Highest Killstreak", data["highest_killstreak"].intValue)),
            
            CellData(headerData: ("Dash Cooldown", (data["dash_cooldown"].intValue) + 1)),
            CellData(headerData: ("Dash Power", (data["dash_power"].intValue) + 1)),
            
            CellData(headerData: ("Solo", ""), sectionData: statsSolo),
            
            CellData(headerData: ("Teams", ""), sectionData: statsTeams)
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
        
        var category = ""
        var value: Any = ""
        
        if indexPath.row == 0 {
            if !statsTableData[indexPath.section].sectionData.isEmpty {
                cell.showDropDown()
            }
            
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
}
