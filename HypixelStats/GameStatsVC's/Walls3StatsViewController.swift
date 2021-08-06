//
//  Walls3StatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/5/21.
//

import Foundation
import UIKit
import SwiftyJSON

class Walls3StatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    var modeCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Mega Walls"
        
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
        var assists = data["assists"].intValue ?? 0
        var deaths = data["deaths"].intValue ?? 0
        var kdr = GameTypes.calculateRatio(numerator: kills, denominator: deaths)
        
        var finalKills = data["final_kills"].intValue ?? 0
        var finalAssists = data["final_assists"].intValue ?? 0
        var finalDeaths = data["final_deaths"].intValue ?? 0
        var finalKDR = GameTypes.calculateRatio(numerator: finalKills, denominator: finalDeaths)
      
        
        var generalStats = [
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Assists", assists), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Final Kills", finalKills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Final Assists", finalAssists), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Final Deaths", finalDeaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Final K/D", finalKDR), sectionData: [], isHeader: false, isOpened: false)
        ]
        
        ret.append(contentsOf: generalStats)
        
        let modes = [
            (id: "_standard", name: "Normal"),
            (id: "_face_off", name: "Face Off"),
            (id: "_gvg", name: "Casual Brawl"),
        ]
        
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D", ]
        
        var modeStats: [CellData] = []
        
        for mode in modes {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins" + mode.id].intValue ?? 0
            var modeLosses = data["losses" + mode.id].intValue ?? 0
            var modeWLR = GameTypes.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills" + mode.id].intValue ?? 0
            var modeDeaths = data["deaths" + mode.id].intValue ?? 0
            var modeKDR = GameTypes.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            if modeWins + modeLosses + modeKills + modeDeaths == 0 {
                continue
            }
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode, isHeader: false, isOpened: false))
        }
        
        ret.append(contentsOf: modeStats)
        modeCount = modeStats.count
        
        var kits = [
            (id: "arcanist", name: "Arcanist", difficulty: "1"),
            (id: "assassin", name: "Assassin", difficulty: "2"),
            (id: "automaton", name: "Automaton", difficulty: "4"),
            (id: "blaze", name: "Blaze", difficulty: "2"),
            (id: "cow", name: "Cow", difficulty: "1"),
            (id: "creeper", name: "Creeper", difficulty: "3"),
            (id: "dreadlord", name: "Dreadlord", difficulty: "1"),
            (id: "enderman", name: "Enderman", difficulty: "2"),
            (id: "golem", name: "Golem", difficulty: "1"),
            (id: "herobrine", name: "Herobrine", difficulty: "1"),
            (id: "hunter", name: "Hunter", difficulty: "2"),
            (id: "moleman", name: "Moleman", difficulty: "3"),
            (id: "phoenix", name: "Phoenix", difficulty: "3"),
            (id: "pigman", name: "Pigman", difficulty: "1"),
            (id: "pirate", name: "Pirate", difficulty: "3"),
            (id: "renegade", name: "Renegade", difficulty: "4"),
            (id: "shaman", name: "Shaman", difficulty: "2"),
            (id: "shark", name: "Shark", difficulty: "3"),
            (id: "skeleton", name: "Skeleton", difficulty: "3"),
            (id: "snowman", name: "Snowman", difficulty: "4"),
            (id: "spider", name: "Spider", difficulty: "3"),
            (id: "squid", name: "Squid", difficulty: "2"),
            (id: "werewolf", name: "Werewolf", difficulty: "2"),
            (id: "zombie", name: "Zombie", difficulty: "1"),
        ]
        
        var desiredKitStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D", "Final Kills", "Final Deaths", "Final K/D"]
        
        var kitStats: [CellData] = []
        
        for kit in kits {
            var statsForThisKit: [(String, Any)] = []
            
            var kitWins = data[kit.id + "_wins"].intValue ?? 0
            var kitLosses = data[kit.id + "_losses"].intValue ?? 0
            var kitWLR = GameTypes.calculateRatio(numerator: kitWins, denominator: kitLosses)
            
            if kitWins + kitLosses == 0 {
                continue
            }
            
            var kitKills = data[kit.id + "_kills"].intValue ?? 0
            var kitDeaths = data[kit.id + "_deaths"].intValue ?? 0
            var kitKDR = GameTypes.calculateRatio(numerator: kitKills, denominator: kitDeaths)
            
            var kitFinalKills = data[kit.id + "_final_kills"].intValue ?? 0
            var kitFinalDeaths = data[kit.id + "_final_deaths"].intValue ?? 0
            var kitFinalKDR = GameTypes.calculateRatio(numerator: kitFinalKills, denominator: kitFinalDeaths)
            
            var kitPrestige = data["classes"][kit.id]["prestige"].intValue ?? 0
            
            var kitPrestigeString = kitPrestige == 0 ? "" : GameTypes.convertToRomanNumerals(number: kitPrestige)
            
            
            var dataForThisKit = [kitWins, kitLosses, kitWLR, kitKills, kitDeaths, kitKDR, kitFinalKills, kitFinalDeaths, kitFinalKDR] as [Any]
            
            for (index, category) in desiredKitStats.enumerated() {
                statsForThisKit.append((category, dataForThisKit[index]))
            }
            
            kitStats.append(CellData(headerData: (kit.name, kitPrestigeString), sectionData: statsForThisKit, isHeader: false, isOpened: false))
        }
        
        ret.append(contentsOf: kitStats)
        
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
        let sectionsThatNeedHeader = [3, 7, 11, 11 + modeCount]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
