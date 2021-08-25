//
//  PaintballStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import Foundation
import UIKit
import SwiftyJSON

class PaintballStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        1: "",
        6: "",
        8: "Perks"
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
       
        
        let shotsFired = data["shots_fired"].intValue
        
        var shotsPerKill = kills == 0 ? Double(shotsFired) : Double(shotsFired) / Double(kills)
        
        var headStart = data["headstart"].intValue
        
        if headStart == 0 {
            headStart = 1
        }
        
        return [
            CellData(headerData: ("Wins", data["wins"].intValue), sectionData: []),
            
            CellData(headerData: ("Kills", kills), sectionData: []),
            CellData(headerData: ("Deaths", deaths), sectionData: []),
            CellData(headerData: ("K/D", kdr), sectionData: []),
            CellData(headerData: ("Shots Fired", shotsFired), sectionData: []),
            CellData(headerData: ("Shots/Kill", String(format: "%.2f", shotsPerKill)), sectionData: []),
            
            CellData(headerData: ("Killstreaks", data["killstreaks"].intValue), sectionData: []),
            CellData(headerData: ("Forcefield Time (seconds)", data["forcefieldTime"].intValue), sectionData: []),
            
            CellData(headerData: ("Adrenaline", (data["adrenaline"].intValue) + 1), sectionData: []),
            CellData(headerData: ("Endurance", (data["endurance"].intValue) + 1), sectionData: []),
            CellData(headerData: ("Fortune", (data["fortune"].intValue) + 1), sectionData: []),
            CellData(headerData: ("Godfather", (data["godfather"].intValue) + 1), sectionData: []),
            CellData(headerData: ("Head Start", headStart), sectionData: []),
            CellData(headerData: ("Superluck", (data["superluck"].intValue) + 1), sectionData: []),
            CellData(headerData: ("Transfusion", (data["transfusion"].intValue) + 1), sectionData: []),
            
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
}
