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
            CellData(headerData: ("Wins", data["wins"].intValue)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            CellData(headerData: ("Shots Fired", shotsFired)),
            CellData(headerData: ("Shots/Kill", String(format: "%.2f", shotsPerKill))),
            
            CellData(headerData: ("Killstreaks", data["killstreaks"].intValue)),
            CellData(headerData: ("Forcefield Time (seconds)", data["forcefieldTime"].intValue)),
            
            CellData(headerData: ("Adrenaline", (data["adrenaline"].intValue) + 1)),
            CellData(headerData: ("Endurance", (data["endurance"].intValue) + 1)),
            CellData(headerData: ("Fortune", (data["fortune"].intValue) + 1)),
            CellData(headerData: ("Godfather", (data["godfather"].intValue) + 1)),
            CellData(headerData: ("Head Start", headStart)),
            CellData(headerData: ("Superluck", (data["superluck"].intValue) + 1)),
            CellData(headerData: ("Transfusion", (data["transfusion"].intValue) + 1)),
            
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
