//
//  SuperSmashStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/31/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SuperSmashStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        4: "",
        7: "Modes",
        10: "Kits"
    ]
    
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var generalStats = [
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            CellData(headerData: ("Smash Level", data["smash_level_total"].intValue), sectionData: [], color: UIColor(named: "mc_aqua")!),
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr))
        ]
        
        ret.append(contentsOf: generalStats)
        
        
        var modeNames = [("normal", "1v1v1v1"), ("2v2", "2v2"), ("teams", "2v2v2")]
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]
        
        var modeStats: [CellData] = []
        
        for mode in modeNames {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins_" + mode.0].intValue
            var modeLosses = data["losses_" + mode.0].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            var modeKills = data["kills_" + mode.0].intValue
            var modeDeaths = data["deaths_" + mode.0].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.1, ""), sectionData: statsForThisMode))
        }
        
        ret.append(contentsOf: modeStats)
        
        
        var kitData = data["class_stats"]
        var kitNames = [
            ("BOTMUN", "Botmon"),
            ("THE_BULK", "Bulk"),
            ("CAKE_MONSTER", "Cake Monster"),
            ("FROSTY", "Cryomancer"),
            ("GENERAL_CLUCK", "General Cluck"),
            ("GREEN_HOOD", "Green Hood"),
            ("GOKU", "Karakot"),
            ("MARAUDER", "Marauder"),
            ("PUG", "Pug"),
            ("SANIC", "Sanic"),
            ("SERGEANT_SHIELD", "Sgt. Shield"),
            ("SHOOP_DA_WHOOP", "Shoop"),
            ("SKULLFIRE", "Skullfire"),
            ("SPODERMAN", "Spooderman"),
            ("TINMAN", "Tinman"),
            ("DUSK_CRAWLER", "Void Crawler")
        ]
        
        var kitStats: [CellData] = []
        
        for kit in kitNames {
            var statsForThisKit: [(String, Any)] = []
            
            if kitData[kit.0].exists() {
                var dataForThisKit = kitData[kit.0]
                
                var kitWins = dataForThisKit["wins"].intValue
                var kitLosses = dataForThisKit["losses"].intValue
                var kitWLR = Utils.calculateRatio(numerator: kitWins, denominator: kitLosses)
                
                var kitKills = dataForThisKit["kills"].intValue
                var kitDeaths = dataForThisKit["deaths"].intValue
                var kitKDR = Utils.calculateRatio(numerator: kitKills, denominator: kitDeaths)
                
                var dataForThisMode = [kitWins, kitLosses, kitWLR, kitKills, kitDeaths, kitKDR] as [Any]
                
                var prestigeAndColor = getPrestigeAndColor(kitName: kit.0)
                
                for (index, category) in desiredStats.enumerated() {
                    statsForThisKit.append((category, dataForThisMode[index]))
                }
                
                kitStats.append(CellData(headerData: (kit.1 + " Lvl" + String(data["lastLevel_" + kit.0].intValue), prestigeAndColor.0), sectionData: statsForThisKit, color: prestigeAndColor.1))
            }
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
                
                if headerTitle == "Kits" {
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
    
    func getPrestigeAndColor(kitName: String) -> (String, UIColor) {
        let prestige = data["pg_" + kitName].intValue
        var prestigeString = ""
        
        if prestige != 0 {
            prestigeString = "\(prestige)"
        }
        var color = UIColor.label
        
        switch prestige {
        case 2:
            color = UIColor(named: "mc_green")!
        case 3:
            color = UIColor(named: "mc_blue")!
        case 4:
            color = UIColor(named: "mc_dark_purple")!
        case 5:
            color = UIColor(named: "mc_gold")!
        default:
            color = .label
        }
        
        return (prestigeString, color)
    }
}
