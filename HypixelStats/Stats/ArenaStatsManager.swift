//
//  ArenaStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/22/21.
//

import Foundation
import UIKit
import SwiftyJSON

class ArenaStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        6: "Modes"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var wins = data["wins"].intValue
        var wins1v1 = data["wins_1v1"].intValue
        var wins2v2 = data["wins_2v2"].intValue
        var wins4v4 = data["wins_4v4"].intValue
        
        var losses1v1 = data["losses_1v1"].intValue
        var losses2v2 = data["losses_2v2"].intValue
        var losses4v4 = data["losses_4v4"].intValue
        var losses = losses1v1 + losses2v2 + losses4v4

        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        var wlr1v1 = Utils.calculateRatio(numerator: wins1v1, denominator: losses1v1)
        var wlr2v2 = Utils.calculateRatio(numerator: wins2v2, denominator: losses2v2)
        var wlr4v4 = Utils.calculateRatio(numerator: wins4v4, denominator: losses4v4)
        
        var kills1v1 = data["kills_1v1"].intValue
        var kills2v2 = data["kills_2v2"].intValue
        var kills4v4 = data["kills_4v4"].intValue
        var kills = kills1v1 + kills2v2 + kills4v4
        
        var deaths1v1 = data["deaths_1v1"].intValue
        var deaths2v2 = data["deaths_2v2"].intValue
        var deaths4v4 = data["deaths_4v4"].intValue
        var deaths = deaths1v1 + deaths2v2 + deaths4v4
        
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        var kdr1v1 = Utils.calculateRatio(numerator: kills1v1, denominator: deaths1v1)
        var kdr2v2 = Utils.calculateRatio(numerator: kills2v2, denominator: deaths2v2)
        var kdr4v4 = Utils.calculateRatio(numerator: kills4v4, denominator: deaths4v4)
        
        let stats1v1: [(String, Any)] = [
            ("Wins", wins1v1),
            ("Losses", losses1v1),
            ("W/L", wlr1v1),
            ("Kills", kills1v1),
            ("Deaths", deaths1v1),
            ("K/D", kdr1v1)
        ]
        
        let stats2v2: [(String, Any)] = [
            ("Wins", wins2v2),
            ("Losses", losses2v2),
            ("W/L", wlr2v2),
            ("Kills", kills2v2),
            ("Deaths", deaths2v2),
            ("K/D", kdr2v2)
        ]
        
        let stats4v4: [(String, Any)] = [
            ("Wins", wins4v4),
            ("Losses", losses4v4),
            ("W/L", wlr4v4),
            ("Kills", kills4v4),
            ("Deaths", deaths4v4),
            ("K/D", kdr4v4)
        ]
        
        return [
            CellData(headerData: ("Wins", wins), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", losses), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", kills), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deaths), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdr), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("1v1", ""), sectionData: stats1v1, isHeader: false, isOpened: false),
            CellData(headerData: ("2v2", ""), sectionData: stats2v2, isHeader: false, isOpened: false),
            CellData(headerData: ("4v4", ""), sectionData: stats4v4, isHeader: false, isOpened: false)
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
