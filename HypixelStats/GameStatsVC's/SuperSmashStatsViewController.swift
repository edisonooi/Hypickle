//
//  SuperSmashStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/31/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SuperSmashStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Smash Heroes"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue ?? 0
        var losses = data["losses"].intValue ?? 0
        var wlr = GameTypes.calculateKDR(kills: wins, deaths: losses)
        
        var kills = data["kills"].intValue ?? 0
        var deaths = data["deaths"].intValue ?? 0
        var kdr = GameTypes.calculateKDR(kills: kills, deaths: deaths)
        
        var generalStats = [
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Smash Level", data["smash_level_total"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false)
        ]
        
        ret.append(contentsOf: generalStats)
        
        
        var modeNames = [("normal", "1v1v1v1"), ("2v2", "2v2"), ("teams", "2v2v2")]
        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]
        
        var modeStats: [CellData] = []
        
        for mode in modeNames {
            var statsForThisMode: [(String, Any)] = []
            
            var modeWins = data["wins_" + mode.0].intValue ?? 0
            var modeLosses = data["losses_" + mode.0].intValue ?? 0
            var modeWLR = GameTypes.calculateKDR(kills: modeWins, deaths: modeLosses)
            
            var modeKills = data["kills_" + mode.0].intValue ?? 0
            var modeDeaths = data["deaths_" + mode.0].intValue ?? 0
            var modeKDR = GameTypes.calculateKDR(kills: modeKills, deaths: modeDeaths)
            
            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]
            
            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }
            
            modeStats.append(CellData(headerData: (mode.1, ""), sectionData: statsForThisMode, isHeader: false, isOpened: false))
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
                
                var kitWins = dataForThisKit["wins"].intValue ?? 0
                var kitLosses = dataForThisKit["losses"].intValue ?? 0
                var kitWLR = GameTypes.calculateKDR(kills: kitWins, deaths: kitLosses)
                
                var kitKills = dataForThisKit["kills"].intValue ?? 0
                var kitDeaths = dataForThisKit["deaths"].intValue ?? 0
                var kitKDR = GameTypes.calculateKDR(kills: kitKills, deaths: kitDeaths)
                
                var dataForThisMode = [kitWins, kitLosses, kitWLR, kitKills, kitDeaths, kitKDR] as [Any]
                
                for (index, category) in desiredStats.enumerated() {
                    statsForThisKit.append((category, dataForThisMode[index]))
                }
                
                kitStats.append(CellData(headerData: (kit.1 + " Lvl" + String(data["lastLevel_" + kit.0].intValue ?? 0), data["pg_" + kit.0].intValue ?? 0), sectionData: statsForThisKit, isHeader: false, isOpened: false))
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
        let sectionsThatNeedHeader = [3, 4, 7, 10]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}



