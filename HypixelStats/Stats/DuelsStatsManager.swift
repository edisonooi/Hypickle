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
    
    let divisions = [
        (name: "Rookie",      color: "darkgray"),
        (name: "Iron",        color: "white"),
        (name: "Gold",        color: "gold"),
        (name: "Diamond",     color: "aqua"),
        (name: "Master",      color: "darkgreen"),
        (name: "Legend",      color: "darkred"),
        (name: "Grandmaster", color: "yellow"),
        (name: "Godlike",     color: "purple"),
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = GameTypes.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        
        var swings = data["melee_swings"].intValue
        var hits = data["melee_hits"].intValue
        var meleeAccuracy = GameTypes.calculatePercentage(numerator: hits, denominator: swings)
        
        var bowShots = data["bow_shots"].intValue
        var bowHits = data["bow_hits"].intValue
        var bowAccuracy = GameTypes.calculatePercentage(numerator: bowHits, denominator: bowShots)
        
        
        var generalStats = [
            CellData(headerData: ("Overall Division", getDivision(modeID: "all_modes")), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Best Overall Winstreak", data["best_overall_winstreak"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Current Winstreak", data["current_winstreak"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Melee Swings", swings), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Melee Hits", hits), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Melee Accuracy", meleeAccuracy), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Arrow Shots", bowShots), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Arrow Hits", bowHits), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Arrow Accuracy", bowAccuracy), sectionData: [], isHeader: false, isOpened: false),

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
            
            var modeWLR = GameTypes.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = mode.divisionId == "bridge" ? data[mode.id + "_bridge_kills"].intValue : data[mode.id + "_kills"].intValue
            var modeDeaths = mode.divisionId == "bridge" ? data[mode.id + "_bridge_deaths"].intValue : data[mode.id + "_deaths"].intValue
            var modeKDR = GameTypes.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var modeCurrentWS = data["current_winstreak_mode_" + mode.id].intValue
            var modeBestWS = data["best_winstreak_mode_" + mode.id].intValue
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR, modeBestWS, modeCurrentWS] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            if mode.divisionId == "bridge" {
                var goals = data[mode.id + "_goals"].intValue
                statsForThisMode.append(("Goals", goals))
            }
            
            modeStats.append(CellData(headerData: (mode.name, getDivision(modeID: mode.divisionId)), sectionData: statsForThisMode, isHeader: false, isOpened: false))
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
        let sectionsThatNeedHeader = [1, 4, 7, 9, 12, 15]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func getDivision(modeID: String) -> String {
        for division in divisions.reversed() {
            let divisionData = data[modeID + "_" + division.name.lowercased() + "_title_prestige"].intValue
            
            if divisionData != 0 {
                let romanNumeral = GameTypes.convertToRomanNumerals(number: divisionData)
                
                return division.name + " " + romanNumeral
            }
        }
        
        return ""
    }
}
