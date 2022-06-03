//
//  WoolGamesStatsManager.swift
//  HypixelStats
//
//  Created by Edison Ooi on 6/2/22.
//

import Foundation
import UIKit
import SwiftyJSON

class WoolGamesManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data["wool_wars"]["stats"]
    }
    
    let headers = [
        3: "",
        7: "",
        10: "Kits"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var wins = data["wins"].intValue
        var gamesPlayed = data["games_played"].intValue
        var losses = gamesPlayed - wins
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var assists = data["assists"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var powerupsGotten = data["powerups_gotten"].intValue
        var woolPlaced = data["wool_placed"].intValue
        var blocksBroken = data["blocks_broken"].intValue
        
        var generalStats = [
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", assists)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Powerups Gotten", powerupsGotten)),
            CellData(headerData: ("Wool Placed", woolPlaced)),
            CellData(headerData: ("Blocks Broken", blocksBroken))
        ]
        
        ret.append(contentsOf: generalStats)
        
        
        var kitData = data["classes"]
        var kitNames = [
            ("archer", "Archer"),
            ("assault", "Assault"),
            ("engineer", "Engineer"),
            ("golem", "Golem"),
            ("tank", "Tank"),
            ("swordsman", "Swordsman")
        ]
        let desiredKitStats = ["Wins", "Losses", "W/L", "Kills", "Assists", "Deaths", "K/D"]
        
        var kitStats: [CellData] = []
        
        for kit in kitNames {
            var statsForThisKit: [(String, Any)] = []
            
            if kitData[kit.0].exists() {
                var dataForThisKit = kitData[kit.0]
                
                var kitWins = dataForThisKit["wins"].intValue
                var kitGamesPlayed = dataForThisKit["games_played"].intValue
                var kitLosses = kitGamesPlayed - kitWins
                var kitWLR = Utils.calculateRatio(numerator: kitWins, denominator: kitLosses)
                
                var kitKills = dataForThisKit["kills"].intValue
                var kitAssists = dataForThisKit["assists"].intValue
                var kitDeaths = dataForThisKit["deaths"].intValue
                var kitKDR = Utils.calculateRatio(numerator: kitKills, denominator: kitDeaths)
                
                var dataForThisMode = [kitWins, kitLosses, kitWLR, kitKills, kitAssists, kitDeaths, kitKDR] as [Any]
                
                for (index, category) in desiredKitStats.enumerated() {
                    statsForThisKit.append((category, dataForThisMode[index]))
                }
                
                kitStats.append(CellData(headerData: (kit.1, ""), sectionData: statsForThisKit))
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
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
