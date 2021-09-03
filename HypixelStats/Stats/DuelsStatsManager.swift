//
//  DuelsStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/4/21.
//

import Foundation
import UIKit
import SwiftyJSON

class DuelsStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        1: "",
        4: "",
        7: "",
        9: "",
        12: "",
        15: "Modes"
    ]
    
    let divisions = [
        (name: "Rookie",      color: UIColor(named: "mc_dark_gray")),
        (name: "Iron",        color: .label),
        (name: "Gold",        color: UIColor(named: "mc_gold")),
        (name: "Diamond",     color: UIColor(named: "mc_cyan")),
        (name: "Master",      color: UIColor(named: "mc_dark_green")),
        (name: "Legend",      color: UIColor(named: "mc_dark_red")),
        (name: "Grandmaster", color: UIColor(named: "mc_yellow")),
        (name: "Godlike",     color: UIColor(named: "mc_dark_purple")),
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var swings = data["melee_swings"].intValue
        var hits = data["melee_hits"].intValue
        var meleeAccuracy = Utils.calculatePercentage(numerator: hits, denominator: swings)
        
        var bowShots = data["bow_shots"].intValue
        var bowHits = data["bow_hits"].intValue
        var bowAccuracy = Utils.calculatePercentage(numerator: bowHits, denominator: bowShots)
        
        var divisionAndColor = getDivision(modeID: "all_modes")
        
        
        var generalStats = [
            CellData(headerData: ("Overall Division", divisionAndColor.0), sectionData: [], color: divisionAndColor.1),
            
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Best Overall Winstreak", data["best_overall_winstreak"].intValue)),
            CellData(headerData: ("Current Winstreak", data["current_winstreak"].intValue)),
            
            CellData(headerData: ("Melee Swings", swings)),
            CellData(headerData: ("Melee Hits", hits)),
            CellData(headerData: ("Melee Accuracy", meleeAccuracy)),
            
            CellData(headerData: ("Arrow Shots", bowShots)),
            CellData(headerData: ("Arrow Hits", bowHits)),
            CellData(headerData: ("Arrow Accuracy", bowAccuracy)),

        ]
        
        ret.append(contentsOf: generalStats)
        
        var modes = [
            (id: "uhc_duel", divisionId: "uhc", name: "UHC 1v1"),
            (id: "uhc_doubles", divisionId: "uhc", name: "UHC 2v2"),
            (id: "uhc_four", divisionId: "uhc", name: "UHC 4v4"),
            (id: "uhc_meetup", divisionId: "uhc", name: "UHC Deathmatch"),
            (id: "op_duel", divisionId: "op",name: "OP 1v1"),
            (id: "op_doubles", divisionId: "op", name: "OP 2v2"),
            (id: "sw_duel", divisionId: "skywars", name: "SkyWars 1v1"),
            (id: "sw_doubles", divisionId: "skywars", name: "SkyWars 2v2"),
            (id: "bow_duel", divisionId: "bow", name: "Bow 1v1"),
            (id: "blitz_duel", divisionId: "blitz", name: "Blitz 1v1"),
            (id: "mw_duel", divisionId: "mega_walls", name: "MegaWalls 1v1"),
            (id: "sumo_duel", divisionId: "sumo", name: "Sumo 1v1"),
            (id: "bowspleef_duel", divisionId: "tnt_games", name: "Bow Spleef 1v1"),
            (id: "classic_duel", divisionId: "classic", name: "Classic 1v1"),
            (id: "potion_duel", divisionId: "no_debuff", name: "NoDebuff 1v1"),
            (id: "combo_duel", divisionId: "combo", name: "Combo 1v1"),
            (id: "bridge_duel", divisionId: "bridge", name: "Bridge 1v1"),
            (id: "bridge_doubles", divisionId: "bridge", name: "Bridge 2v2"),
            (id: "bridge_2v2v2v2", divisionId: "bridge", name: "Bridge 2v2v2v2"),
            (id: "bridge_3v3v3v3", divisionId: "bridge", name: "Bridge 3v3v3v3"),
            (id: "bridge_four", divisionId: "bridge", name: "Bridge 4v4")
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D", "Best Winstreak", "Current Winstreak"]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data[mode.id + "_wins"].intValue
            var modeLosses = data[mode.id + "_losses"].intValue
            
            if modeWins + modeLosses == 0 {
                continue
            }
            
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = mode.divisionId == "bridge" ? data[mode.id + "_bridge_kills"].intValue : data[mode.id + "_kills"].intValue
            var modeDeaths = mode.divisionId == "bridge" ? data[mode.id + "_bridge_deaths"].intValue : data[mode.id + "_deaths"].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeCurrentWS = data["current_winstreak_mode_" + mode.id].intValue
            var modeBestWS = data["best_winstreak_mode_" + mode.id].intValue
            
            var modeDivisonAndColor = getDivision(modeID: mode.divisionId)
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR, modeBestWS, modeCurrentWS] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            if mode.divisionId == "bridge" {
                var goals = data[mode.id + "_goals"].intValue
                statsForThisMode.append(("Goals", goals))
            }
            
            modeStats.append(CellData(headerData: (mode.name, modeDivisonAndColor.0), sectionData: statsForThisMode, color: modeDivisonAndColor.1))
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
    
    func getDivision(modeID: String) -> (String, UIColor) {
        for division in divisions.reversed() {
            let divisionData = data[modeID + "_" + division.name.lowercased() + "_title_prestige"].intValue
            
            if divisionData != 0 {
                let romanNumeral = Utils.convertToRomanNumerals(number: divisionData)
                
                return (division.name + " " + romanNumeral, division.color!)
            }
        }
        
        return ("", .label)
    }
}
