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
        (name: "Rookie",        color: UIColor.MinecraftColors.darkGray),
        (name: "Iron",          color: .label),
        (name: "Gold",          color: UIColor.MinecraftColors.gold),
        (name: "Diamond",       color: UIColor.MinecraftColors.cyan),
        (name: "Master",        color: UIColor.MinecraftColors.darkGreen),
        (name: "Legend",        color: UIColor.MinecraftColors.darkRed),
        (name: "Grandmaster",   color: UIColor.MinecraftColors.yellow),
        (name: "Godlike",       color: UIColor.MinecraftColors.darkPurple),
        (name: "World Elite",   color: UIColor.MinecraftColors.aqua),
        (name: "World Master",  color: UIColor.MinecraftColors.lightPurple),
        (name: "WORLD'S BEST",  color: UIColor.MinecraftColors.gold),
        
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
            
            (id: "boxing_duel", divisionId: "boxing", name: "Boxing 1v1"),
            (id: "duel_arena", divisionId: "", name: "Duel Arena"),
            //(id: "capture_duel", divisionId: "bridge", name: "Capture??"),
            (id: "parkour_eight", divisionId: "parkour", name: "Parkour 8 Player FFA"),
            
            (id: "bridge_duel", divisionId: "bridge", name: "Bridge 1v1"),
            (id: "bridge_doubles", divisionId: "bridge", name: "Bridge 2v2"),
            (id: "bridge_2v2v2v2", divisionId: "bridge", name: "Bridge 2v2v2v2"),
            
            (id: "bridge_threes", divisionId: "bridge", name: "Bridge 3v3"),
            
            (id: "bridge_3v3v3v3", divisionId: "bridge", name: "Bridge 3v3v3v3"),
            (id: "bridge_four", divisionId: "bridge", name: "Bridge 4v4"),
            
            (id: "capture_threes", divisionId: "bridge", name: "Bridge CTF 3v3")
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
                if mode.id == "capture_threes" {
                    statsForThisMode.append(("Captures", data["captures"].intValue))
                } else {
                    var goals = data[mode.id + "_goals"].intValue
                    statsForThisMode.append(("Goals", goals))
                }
                
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
        
        cell.configureDefault(statsTableData: statsTableData, indexPath: indexPath)

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
                
                if headerTitle == "Modes" {
                    headerView.rightLabel.text = "Division"
                }
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func getDivision(modeID: String) -> (String, UIColor) {
        if modeID == "" {
            return ("N/A", UIColor.MinecraftColors.darkGray)
        }
        
        for division in divisions.reversed() {
            
            let divisionData = data[modeID + "_" + division.name.lowercased().replacingOccurrences(of: "'", with: "").replacingOccurrences(of: " ", with: "_") + "_title_prestige"].intValue
            
            if divisionData != 0 {
                let romanNumeral = Utils.convertToRomanNumerals(number: divisionData)
                
                return (division.name + " " + romanNumeral, division.color)
            }
        }
        
        return ("", .label)
    }
}
