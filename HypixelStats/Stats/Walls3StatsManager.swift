//
//  Walls3StatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/5/21.
//

import Foundation
import UIKit
import SwiftyJSON

class Walls3StatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    var modeCount = 0
    var hasPrestige = false
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var assists = data["assists"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var finalKills = data["final_kills"].intValue
        var finalAssists = data["final_assists"].intValue
        var finalDeaths = data["final_deaths"].intValue
        var finalKDR = Utils.calculateRatio(numerator: finalKills, denominator: finalDeaths)
      
        
        var generalStats = [
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", assists)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Final Kills", finalKills)),
            CellData(headerData: ("Final Assists", finalAssists)),
            CellData(headerData: ("Final Deaths", finalDeaths)),
            CellData(headerData: ("Final K/D", finalKDR))
        ]
        
        ret.append(contentsOf: generalStats)
        
        let modes = [
            (id: "_standard", name: "Normal"),
            (id: "_face_off", name: "Face Off"),
            (id: "_gvg", name: "Casual Brawl"),
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
            
            if modeWins + modeLosses + modeKills + modeDeaths == 0 {
                continue
            }
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            
            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
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
            
            var kitWins = data[kit.id + "_wins"].intValue
            var kitLosses = data[kit.id + "_losses"].intValue
            var kitWLR = Utils.calculateRatio(numerator: kitWins, denominator: kitLosses)
            
            if kitWins + kitLosses == 0 {
                continue
            }
            
            var kitKills = data[kit.id + "_kills"].intValue
            var kitDeaths = data[kit.id + "_deaths"].intValue
            var kitKDR = Utils.calculateRatio(numerator: kitKills, denominator: kitDeaths)
            
            var kitFinalKills = data[kit.id + "_final_kills"].intValue
            var kitFinalDeaths = data[kit.id + "_final_deaths"].intValue
            var kitFinalKDR = Utils.calculateRatio(numerator: kitFinalKills, denominator: kitFinalDeaths)
            
            var kitPrestige = data["classes"][kit.id]["prestige"].intValue
            if kitPrestige > 0 {
                hasPrestige = true
            }
            
            var kitPrestigeString = kitPrestige == 0 ? "" : Utils.convertToRomanNumerals(number: kitPrestige)
            
            
            var dataForThisKit = [kitWins, kitLosses, kitWLR, kitKills, kitDeaths, kitKDR, kitFinalKills, kitFinalDeaths, kitFinalKDR] as [Any]
            
            for (index, category) in desiredKitStats.enumerated() {
                statsForThisKit.append((category, dataForThisKit[index]))
            }
            
            kitStats.append(CellData(headerData: (kit.name, kitPrestigeString), sectionData: statsForThisKit))
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
        let headers = [
            3: "",
            7: "",
            11: "Modes"
        ]
        
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                return 32
            } else {
                return 64
            }
        }
        
        if section == 11 + modeCount {
            return 64
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headers = [
            3: "",
            7: "",
            11: "Modes",
        ]
        
        if modeCount == 0 {
            headers[11] = "Kits"
        } else {
            headers[11 + modeCount] = "Kits"
        }
        
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 32))
                headerView.backgroundColor = .clear
                
                return headerView
                
            } else {
                
                let headerView = GenericHeaderView.instanceFromNib()
                headerView.title.text = headerTitle
                
                if headerTitle == "Kits" && hasPrestige {
                    headerView.rightLabel.text = "Prestige"
                }
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
