//
//  TNTGamesStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/22/21.
//

import Foundation
import UIKit
import SwiftyJSON

class TNTGamesStatsViewController: GenericStatsViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "TNT Games"
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.delegate = self
        statsTable.dataSource = self
        
    }
    
    lazy var statsTableData: [CellData] = {
        
        //Yes this is gross and inefficient, I know
        
        var winsTNTRun = data["wins_tntrun"].intValue ?? 0
        var lossesTNTRun = data["deaths_tntrun"].intValue ?? 0
        var wlrTNTRun = GameTypes.calculateRatio(numerator: winsTNTRun, denominator: lossesTNTRun)
        
        var winsPVPRun = data["wins_pvprun"].intValue ?? 0
        var killsPVPRun = data["kills_pvprun"].intValue ?? 0
        var lossesPVPRun = data["deaths_pvprun"].intValue ?? 0
        var wlrPVPRun = GameTypes.calculateRatio(numerator: winsPVPRun, denominator: lossesPVPRun)
        var kdrPVPRun = GameTypes.calculateRatio(numerator: killsPVPRun, denominator: lossesPVPRun)
        
        var winsSpleef = data["wins_bowspleef"].intValue ?? 0
        var lossesSpleef = data["deaths_bowspleef"].intValue ?? 0
        var wlrSpleef = GameTypes.calculateRatio(numerator: winsSpleef, denominator: lossesSpleef)
        
        var winsTag = data["wins_tntag"].intValue ?? 0
        
        var winsWizards = data["wins_capture"].intValue ?? 0
        var killsWizards = data["kills_capture"].intValue ?? 0
        var deathsWizards = data["deaths_capture"].intValue ?? 0
        var kdrWizards = GameTypes.calculateRatio(numerator: killsWizards, denominator: deathsWizards)
        
        var killsAncient = data["new_ancientwizard_kills"].intValue ?? 0
        var deathsAncient = data["new_ancientwizard_deaths"].intValue ?? 0
        var kdrAncient = GameTypes.calculateRatio(numerator: killsAncient, denominator: deathsAncient)
        
        var killsBlood = data["new_bloodwizard_kills"].intValue ?? 0
        var deathsBlood = data["new_bloodwizard_deaths"].intValue ?? 0
        var kdrBlood = GameTypes.calculateRatio(numerator: killsBlood, denominator: deathsBlood)
        
        var killsFire = data["new_firewizard_kills"].intValue ?? 0
        var deathsFire = data["new_firewizard_deaths"].intValue ?? 0
        var kdrFire = GameTypes.calculateRatio(numerator: killsFire, denominator: deathsFire)
        
        var killsHydro = data["new_hydrowizard_kills"].intValue ?? 0
        var deathsHydro = data["new_hydrowizard_deaths"].intValue ?? 0
        var kdrHydro = GameTypes.calculateRatio(numerator: killsHydro, denominator: deathsHydro)
        
        var killsIce = data["new_icewizard_kills"].intValue ?? 0
        var deathsIce = data["new_icewizard_deaths"].intValue ?? 0
        var kdrIce = GameTypes.calculateRatio(numerator: killsIce, denominator: deathsIce)
        
        var killsKinetic = data["new_kineticwizard_kills"].intValue ?? 0
        var deathsKinetic = data["new_kineticwizard_deaths"].intValue ?? 0
        var kdrKinetic = GameTypes.calculateRatio(numerator: killsKinetic, denominator: deathsKinetic)
        
        var killsStorm = data["new_stormwizard_kills"].intValue ?? 0
        var deathsStorm = data["new_stormwizard_deaths"].intValue ?? 0
        var kdrStorm = GameTypes.calculateRatio(numerator: killsStorm, denominator: deathsStorm)
        
        var killsToxic = data["new_toxicwizard_kills"].intValue ?? 0
        var deathsToxic = data["new_toxicwizard_deaths"].intValue ?? 0
        var kdrToxic = GameTypes.calculateRatio(numerator: killsToxic, denominator: deathsToxic)
        
        var killsWither = data["new_witherwizard_kills"].intValue ?? 0
        var deathsWither = data["new_witherwizard_deaths"].intValue ?? 0
        var kdrWither = GameTypes.calculateRatio(numerator: killsWither, denominator: deathsWither)
        
        let statsAncient: [(String, Any)] = [
            ("Kills", killsAncient),
            ("Deaths", deathsAncient),
            ("Assists", data["new_ancientwizard_assists"].intValue ?? 0),
            ("K/D", kdrAncient)
        ]
        
        let statsBlood: [(String, Any)] = [
            ("Kills", killsBlood),
            ("Deaths", deathsBlood),
            ("Assists", data["new_bloodwizard_assists"].intValue ?? 0),
            ("K/D", kdrBlood)
        ]
        
        let statsFire: [(String, Any)] = [
            ("Kills", killsFire),
            ("Deaths", deathsFire),
            ("Assists", data["new_firewizard_assists"].intValue ?? 0),
            ("K/D", kdrFire)
        ]
        
        let statsHydro: [(String, Any)] = [
            ("Kills", killsHydro),
            ("Deaths", deathsHydro),
            ("Assists", data["new_hydrowizard_assists"].intValue ?? 0),
            ("K/D", kdrHydro)
        ]
        
        let statsIce: [(String, Any)] = [
            ("Kills", killsIce),
            ("Deaths", deathsIce),
            ("Assists", data["new_icewizard_assists"].intValue ?? 0),
            ("K/D", kdrIce)
        ]
        
        let statsKinetic: [(String, Any)] = [
            ("Kills", killsKinetic),
            ("Deaths", deathsKinetic),
            ("Assists", data["new_kineticwizard_assists"].intValue ?? 0),
            ("K/D", kdrKinetic)
        ]
        
        let statsStorm: [(String, Any)] = [
            ("Kills", killsStorm),
            ("Deaths", deathsStorm),
            ("Assists", data["new_stormwizard_assists"].intValue ?? 0),
            ("K/D", kdrStorm)
        ]
        
        let statsToxic: [(String, Any)] = [
            ("Kills", killsToxic),
            ("Deaths", deathsToxic),
            ("Assists", data["new_toxicwizard_assists"].intValue ?? 0),
            ("K/D", kdrToxic)
        ]
        
        let statsWither: [(String, Any)] = [
            ("Kills", killsWither),
            ("Deaths", deathsWither),
            ("Assists", data["new_witherwizard_assists"].intValue ?? 0),
            ("K/D", kdrWither)
        ]
        
        
        
        return [
            CellData(headerData: ("Wins", winsTNTRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", lossesTNTRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlrTNTRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Record Time", GameTypes.formatMinuteSeconds(totalSeconds: data["record_tntrun"].intValue ?? 0)), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Wins", winsPVPRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", killsPVPRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", lossesPVPRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlrPVPRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdrPVPRun), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Record Time", GameTypes.formatMinuteSeconds(totalSeconds: data["record_pvprun"].intValue ?? 0)), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Wins", winsSpleef), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Losses", lossesSpleef), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("W/L", wlrSpleef), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Wins", winsTag), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Wins", winsWizards), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Kills", killsWizards), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Deaths", deathsWizards), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("Assists", data["assists_capture"].intValue ?? 0), sectionData: [], isHeader: false, isOpened: false),
            CellData(headerData: ("K/D", kdrWizards), sectionData: [], isHeader: false, isOpened: false),
            
            CellData(headerData: ("Ancient", ""), sectionData: statsAncient, isHeader: false, isOpened: false),
            CellData(headerData: ("Blood", ""), sectionData: statsBlood, isHeader: false, isOpened: false),
            CellData(headerData: ("Fire", ""), sectionData: statsFire, isHeader: false, isOpened: false),
            CellData(headerData: ("Hydro", ""), sectionData: statsHydro, isHeader: false, isOpened: false),
            CellData(headerData: ("Ice", ""), sectionData: statsIce, isHeader: false, isOpened: false),
            CellData(headerData: ("Kinetic", ""), sectionData: statsKinetic, isHeader: false, isOpened: false),
            CellData(headerData: ("Storm", ""), sectionData: statsStorm, isHeader: false, isOpened: false),
            CellData(headerData: ("Toxic", ""), sectionData: statsToxic, isHeader: false, isOpened: false),
            CellData(headerData: ("Wither", ""), sectionData: statsWither, isHeader: false, isOpened: false)
            
            
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
        
        let sectionsThatNeedHeader = [4, 10, 13, 14, 19]
        
        if sectionsThatNeedHeader.contains(section) {
            return 32
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
}

