//
//  TNTGamesStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/22/21.
//

import Foundation
import UIKit
import SwiftyJSON

class TNTGamesStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        0: (image: "walls_icon", title: "TNT Run"),
        4: (image: "pvp_run_icon", title: "PVP Run"),
        10: (image: "murdermystery_icon", title: "Bow Spleef"),
        13: (image: "tnt_tag_icon", title: "TNT Tag"),
        14: (image: "quake_icon", title: "Wizards"),
        19: (image: "", title: "Kits")
    ]
    
    lazy var statsTableData: [CellData] = {
        
        //Yes this is gross and inefficient, I know
        
        var winsTNTRun = data["wins_tntrun"].intValue
        var lossesTNTRun = data["deaths_tntrun"].intValue
        var wlrTNTRun = Utils.calculateRatio(numerator: winsTNTRun, denominator: lossesTNTRun)
        
        var winsPVPRun = data["wins_pvprun"].intValue
        var killsPVPRun = data["kills_pvprun"].intValue
        var lossesPVPRun = data["deaths_pvprun"].intValue
        var wlrPVPRun = Utils.calculateRatio(numerator: winsPVPRun, denominator: lossesPVPRun)
        var kdrPVPRun = Utils.calculateRatio(numerator: killsPVPRun, denominator: lossesPVPRun)
        
        var winsSpleef = data["wins_bowspleef"].intValue
        var lossesSpleef = data["deaths_bowspleef"].intValue
        var wlrSpleef = Utils.calculateRatio(numerator: winsSpleef, denominator: lossesSpleef)
        
        var winsTag = data["wins_tntag"].intValue
        
        var winsWizards = data["wins_capture"].intValue
        var killsWizards = data["kills_capture"].intValue
        var deathsWizards = data["deaths_capture"].intValue
        var kdrWizards = Utils.calculateRatio(numerator: killsWizards, denominator: deathsWizards)
        
        var killsAncient = data["new_ancientwizard_kills"].intValue
        var deathsAncient = data["new_ancientwizard_deaths"].intValue
        var kdrAncient = Utils.calculateRatio(numerator: killsAncient, denominator: deathsAncient)
        
        var killsBlood = data["new_bloodwizard_kills"].intValue
        var deathsBlood = data["new_bloodwizard_deaths"].intValue
        var kdrBlood = Utils.calculateRatio(numerator: killsBlood, denominator: deathsBlood)
        
        var killsFire = data["new_firewizard_kills"].intValue
        var deathsFire = data["new_firewizard_deaths"].intValue
        var kdrFire = Utils.calculateRatio(numerator: killsFire, denominator: deathsFire)
        
        var killsHydro = data["new_hydrowizard_kills"].intValue
        var deathsHydro = data["new_hydrowizard_deaths"].intValue
        var kdrHydro = Utils.calculateRatio(numerator: killsHydro, denominator: deathsHydro)
        
        var killsIce = data["new_icewizard_kills"].intValue
        var deathsIce = data["new_icewizard_deaths"].intValue
        var kdrIce = Utils.calculateRatio(numerator: killsIce, denominator: deathsIce)
        
        var killsKinetic = data["new_kineticwizard_kills"].intValue
        var deathsKinetic = data["new_kineticwizard_deaths"].intValue
        var kdrKinetic = Utils.calculateRatio(numerator: killsKinetic, denominator: deathsKinetic)
        
        var killsStorm = data["new_stormwizard_kills"].intValue
        var deathsStorm = data["new_stormwizard_deaths"].intValue
        var kdrStorm = Utils.calculateRatio(numerator: killsStorm, denominator: deathsStorm)
        
        var killsToxic = data["new_toxicwizard_kills"].intValue
        var deathsToxic = data["new_toxicwizard_deaths"].intValue
        var kdrToxic = Utils.calculateRatio(numerator: killsToxic, denominator: deathsToxic)
        
        var killsWither = data["new_witherwizard_kills"].intValue
        var deathsWither = data["new_witherwizard_deaths"].intValue
        var kdrWither = Utils.calculateRatio(numerator: killsWither, denominator: deathsWither)
        
        let statsAncient: [(String, Any)] = [
            ("Kills", killsAncient),
            ("Deaths", deathsAncient),
            ("Assists", data["new_ancientwizard_assists"].intValue),
            ("K/D", kdrAncient)
        ]
        
        let statsBlood: [(String, Any)] = [
            ("Kills", killsBlood),
            ("Deaths", deathsBlood),
            ("Assists", data["new_bloodwizard_assists"].intValue),
            ("K/D", kdrBlood)
        ]
        
        let statsFire: [(String, Any)] = [
            ("Kills", killsFire),
            ("Deaths", deathsFire),
            ("Assists", data["new_firewizard_assists"].intValue),
            ("K/D", kdrFire)
        ]
        
        let statsHydro: [(String, Any)] = [
            ("Kills", killsHydro),
            ("Deaths", deathsHydro),
            ("Assists", data["new_hydrowizard_assists"].intValue),
            ("K/D", kdrHydro)
        ]
        
        let statsIce: [(String, Any)] = [
            ("Kills", killsIce),
            ("Deaths", deathsIce),
            ("Assists", data["new_icewizard_assists"].intValue),
            ("K/D", kdrIce)
        ]
        
        let statsKinetic: [(String, Any)] = [
            ("Kills", killsKinetic),
            ("Deaths", deathsKinetic),
            ("Assists", data["new_kineticwizard_assists"].intValue),
            ("K/D", kdrKinetic)
        ]
        
        let statsStorm: [(String, Any)] = [
            ("Kills", killsStorm),
            ("Deaths", deathsStorm),
            ("Assists", data["new_stormwizard_assists"].intValue),
            ("K/D", kdrStorm)
        ]
        
        let statsToxic: [(String, Any)] = [
            ("Kills", killsToxic),
            ("Deaths", deathsToxic),
            ("Assists", data["new_toxicwizard_assists"].intValue),
            ("K/D", kdrToxic)
        ]
        
        let statsWither: [(String, Any)] = [
            ("Kills", killsWither),
            ("Deaths", deathsWither),
            ("Assists", data["new_witherwizard_assists"].intValue),
            ("K/D", kdrWither)
        ]
        
        
        
        return [
            CellData(headerData: ("Wins", winsTNTRun), sectionData: []),
            CellData(headerData: ("Losses", lossesTNTRun), sectionData: []),
            CellData(headerData: ("W/L", wlrTNTRun), sectionData: []),
            CellData(headerData: ("Record Time", Utils.formatMinuteSeconds(totalSeconds: data["record_tntrun"].intValue)), sectionData: []),
            
            CellData(headerData: ("Wins", winsPVPRun), sectionData: []),
            CellData(headerData: ("Kills", killsPVPRun), sectionData: []),
            CellData(headerData: ("Deaths", lossesPVPRun), sectionData: []),
            CellData(headerData: ("W/L", wlrPVPRun), sectionData: []),
            CellData(headerData: ("K/D", kdrPVPRun), sectionData: []),
            CellData(headerData: ("Record Time", Utils.formatMinuteSeconds(totalSeconds: data["record_pvprun"].intValue)), sectionData: []),
            
            CellData(headerData: ("Wins", winsSpleef), sectionData: []),
            CellData(headerData: ("Losses", lossesSpleef), sectionData: []),
            CellData(headerData: ("W/L", wlrSpleef), sectionData: []),
            
            CellData(headerData: ("Wins", winsTag), sectionData: []),
            
            CellData(headerData: ("Wins", winsWizards), sectionData: []),
            CellData(headerData: ("Kills", killsWizards), sectionData: []),
            CellData(headerData: ("Deaths", deathsWizards), sectionData: []),
            CellData(headerData: ("Assists", data["assists_capture"].intValue), sectionData: []),
            CellData(headerData: ("K/D", kdrWizards), sectionData: []),
            
            CellData(headerData: ("Ancient", ""), sectionData: statsAncient),
            CellData(headerData: ("Blood", ""), sectionData: statsBlood),
            CellData(headerData: ("Fire", ""), sectionData: statsFire),
            CellData(headerData: ("Hydro", ""), sectionData: statsHydro),
            CellData(headerData: ("Ice", ""), sectionData: statsIce),
            CellData(headerData: ("Kinetic", ""), sectionData: statsKinetic),
            CellData(headerData: ("Storm", ""), sectionData: statsStorm),
            CellData(headerData: ("Toxic", ""), sectionData: statsToxic),
            CellData(headerData: ("Wither", ""), sectionData: statsWither)
            
            
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
        
        if let headerInfo = headers[section] {
            if headerInfo.image == "" {
                if headerInfo.title == "" {
                    return 32
                } else {
                    return 64
                }
            } else {
                return 100
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerInfo = headers[section] {
            if headerInfo.image == "" {
                if headerInfo.title == "" {
                    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 32))
                    headerView.backgroundColor = .clear
                    
                    return headerView
                } else {
                    let headerView = GenericHeaderView.instanceFromNib()
                    headerView.title.text = headerInfo.title
                    
                    return headerView
                }
            } else {
                let headerView = MinigameHeaderView.instanceFromNib()
                headerView.icon.image = UIImage(named: headerInfo.image)
                headerView.title.text = headerInfo.title
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
}

