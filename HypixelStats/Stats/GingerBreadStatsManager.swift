//
//  GingerbreadStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 8/1/21.
//

import Foundation
import UIKit
import SwiftyJSON

class GingerBreadStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    lazy var statsTableData: [CellData] = {
        
        var wins = data["wins"].intValue
        var gamesPlayed = 0
        
        let maps = ["retro", "canyon", "junglerush", "hypixelgp", "olympus"]
        
        for map in maps {
            let plays = data[map + "_plays"].intValue
            gamesPlayed += plays
        }
        
        var podiumPercentage = String(format: "%.2f", (Double(wins) / Double(gamesPlayed)) * 100)
        
        let rarities = [
            "BASIC": "Basic",
            "SUPER": "Super",
            "AWESOME": "Awesome"
        ]
        
        let qualities = [
            (name: "Starter", color: "gray"),
            (name: "Mini", color: "gray"),
            (name: "Auxiliary", color: "green"),
            (name: "Standard", color: "green"),
            (name: "Primary", color: "green"),
            (name: "Experimental", color: "green"),
            (name: "Dynamic", color: "blue"),
            (name: "Stellar", color: "blue"),
            (name: "Kinetic", color: "blue"),
            (name: "Multi-phase", color: "blue"),
            (name: "Turbocharged", color: "pink"),
            (name: "Quantum", color: "pink"),
            (name: "Superluminal", color: "pink"),
            (name: "Psi", color: "pink"),
            (name: "Eternal", color: "purple")
        ]
        
        let kartAttributes = [
            "ACCELERATION": "Acceleration",
            "BOOSTER_SPEED": "Booster Speed",
            "BRAKES": "Brakes",
            "DRIFTING_EFFICIENCY": "Drifting Efficiency",
            "HANDLING": "Handling",
            "RECOVERY": "Recovery",
            "START_POSITION": "Start Position",
            "TOP_SPEED": "Top Speed",
            "TRACTION": "Traction",
        ]
        
        let partTypes = ["engine", "frame", "booster"]
        
        var partStats: [(String, Any)] = []
        
        for part in partTypes {
            var dataForThisPart = convertToValidJSON(str: data[part + "_active"]["GingerbreadPart"].string ?? "")
            
            var partTypeClean = dataForThisPart["PartType"].stringValue
            
            if dataForThisPart["Attributes"].exists() {
                var statsForThisPart: [(String, Any)] = []
                
                var partRarity = rarities[dataForThisPart["PartType"].stringValue]
                
                
            } else {
                partStats.append(("No \(partTypeClean.lowercased().capitalized) Equipped", ""))
            }
            
            
            
        }
        
        
        
        
        
        
        
        
        
        return [
            CellData(headerData: ("Gold Trophies", data["gold_trophy"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Silver Trophies", data["silver_trophy"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Bronze Trophies", data["bronze_trophy"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Games Played", gamesPlayed), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("% Games on Podium", podiumPercentage + "%"), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Coins Picked Up", data["coins_picked_up"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Powerups Picked Up", data["box_pickups"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Blue Torpedoes Hit", data["blue_torpedo_hit"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Banana Hits Sent", data["banana_hits_sent"].intValue), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Banana Hits Received", data["banana_hits_received"].intValue), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Kart Info", ""), sectionData: partStats, isHeader: false, isOpened: true)
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
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
        } else {
            category = statsTableData[indexPath.section].sectionData[indexPath.row - 1].0
            value = statsTableData[indexPath.section].sectionData[indexPath.row - 1].1
        }
        
        if value is Int {
            value = (value as! Int).withCommas
        }
        
        cell.configure(category: category, value: "\(value)")

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
        
        let sectionsThatNeedHeader = [5]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func convertToValidJSON(str: String) -> JSON {
        if str == "" {
            return ""
        }
        
        let chars = ["{","}","[","]",",",":"]
        var newStr = str[0]
        
        for i in 1..<str.count {
            
            if (chars.contains(str[i-1]) && !chars.contains(str[i])) || (!chars.contains(str[i-1]) && chars.contains(str[i])) {
                newStr += "\""
            }
            
            newStr += str[i]
        }
        
        return JSON.init(parseJSON: newStr)
    }
}
