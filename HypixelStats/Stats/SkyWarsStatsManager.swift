//
//  SkyWarsStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/15/21.
//

import Foundation
import UIKit
import SwiftyJSON

class SkyWarsStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    
    init(data: JSON) {
        self.data = data
    }
    
    let headers = [
        3: "",
        7: "",
        11: "",
        15: "",
        18: "",
        20: "",
        23: "",
        25: "",
        29: "Modes"
    ]
    
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var level = getLevel(playerXP: data["skywars_experience"].intValue)
        var prestigeAndColor = getPrestige(level: level)
        
        var wins = data["wins"].intValue
        var losses = data["losses"].intValue
        var wlr = Utils.calculateRatio(numerator: wins, denominator: losses)
        
        var kills = data["kills"].intValue
        var deaths = data["deaths"].intValue
        var kdr = Utils.calculateRatio(numerator: kills, denominator: deaths)
        
        var arrowsShot = data["arrows_shot"].intValue
        var arrowsHit = data["arrows_hit"].intValue
        var arrowAccuracy = Utils.calculatePercentage(numerator: arrowsHit, denominator: arrowsShot)
        
        
        var generalStats = [
            
            CellData(headerData: ("Level", String(format: "%.2f", level)), sectionData: [], color: prestigeAndColor.1),
            CellData(headerData: ("Prestige", prestigeAndColor.0), sectionData: [], color: prestigeAndColor.1),
            CellData(headerData: ("Tokens", data["cosmetic_tokens"].intValue), sectionData: [], color: UIColor(named: "mc_dark_green")!),
            
            CellData(headerData: ("Wins", wins)),
            CellData(headerData: ("Lab Wins", data["wins_lab"].intValue)),
            CellData(headerData: ("Losses", losses)),
            CellData(headerData: ("W/L", wlr)),
            
            CellData(headerData: ("Kills", kills)),
            CellData(headerData: ("Assists", data["assists"].intValue)),
            CellData(headerData: ("Deaths", deaths)),
            CellData(headerData: ("K/D", kdr)),
            
            CellData(headerData: ("Melee Kills", data["melee_kills"].intValue)),
            CellData(headerData: ("Bow Kills", data["bow_kills"].intValue)),
            CellData(headerData: ("Void Kills", data["void_kills"].intValue)),
            CellData(headerData: ("Mob Kills", data["mob_kills"].intValue)),
            
            CellData(headerData: ("Arrows Shot", arrowsShot)),
            CellData(headerData: ("Arrows Hit", arrowsHit)),
            CellData(headerData: ("Arrow Accuracy", arrowAccuracy)),
            
            CellData(headerData: ("Eggs Thrown", data["egg_thrown"].intValue)),
            CellData(headerData: ("Pearls Thrown", data["enderpearls_thrown"].intValue)),
            
            CellData(headerData: ("Blocks Placed", data["blocks_placed"].intValue)),
            CellData(headerData: ("Blocks Broken", data["blocks_broken"].intValue)),
            CellData(headerData: ("Chests Opened", data["chests_opened"].intValue)),
            
            CellData(headerData: ("Heads Gathered", data["heads"].intValue)),
            CellData(headerData: ("Corruption Chance", getCorruptionChance())),
            
            CellData(headerData: ("Souls Gathered", data["souls_gathered"].intValue), sectionData: [], color: UIColor(named: "mc_aqua")!),
            CellData(headerData: ("Current Souls", data["souls"].intValue), sectionData: [], color: UIColor(named: "mc_aqua")!),
            CellData(headerData: ("Paid Souls", data["paid_souls"].intValue), sectionData: [], color: UIColor(named: "mc_aqua")!),
            CellData(headerData: ("Soul Well Uses", data["soul_well"].intValue)),
        ]
        
        ret.append(contentsOf: generalStats)
        
        let modes = [
            (id: "_solo_normal",  name: "Solo Normal"),
            (id: "_solo_insane",  name: "Solo Insane"),
            (id: "_team_normal",  name: "Teams Normal"),
            (id: "_team_insane",  name: "Teams Insane"),
            (id: "_mega_normal",  name: "Mega"),
            (id: "_mega_doubles", name: "Mega Doubles"),
            (id: "_ranked",       name: "Ranked")
        ]

        var desiredStats = ["Wins", "Losses", "W/L", "Kills", "Deaths", "K/D"]

        var modeStats: [CellData] = []

        for mode in modes {
            var statsForThisMode: [(String, Any)] = []

            var modeWins = data["wins" + mode.id].intValue
            var modeLosses = data["losses" + mode.id].intValue
            var modeWLR = Utils.calculateRatio(numerator: modeWins, denominator: modeLosses)
            
            if modeWins + modeLosses == 0 {
                continue
            }

            var modeKills = data["kills" + mode.id].intValue
            var modeDeaths = data["deaths" + mode.id].intValue
            var modeKDR = Utils.calculateRatio(numerator: modeKills, denominator: modeDeaths)

            var dataForThisMode = [modeWins, modeLosses, modeWLR, modeKills, modeDeaths, modeKDR] as [Any]

            for (index, category) in desiredStats.enumerated() {
                statsForThisMode.append((category, dataForThisMode[index]))
            }

            modeStats.append(CellData(headerData: (mode.name, ""), sectionData: statsForThisMode))
        }

        ret.append(contentsOf: modeStats)
        
        
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
                if statsTableData[indexPath.section].color == .clear {
                    let gradientImage = UIImage.gradientImageWithBounds(bounds: cell.statValue.bounds, colors: [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor])
                    cell.statValue.textColor = UIColor.init(patternImage: gradientImage)
                } else {
                    cell.statValue.textColor = statsTableData[indexPath.section].color
                }
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
                
                return headerView
            }
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func getCorruptionChance() -> String {
        var chance = 0
        
        chance += data["angel_of_death_level"].intValue
        chance += data["angels_offering"].intValue
        
        let packagesArray = data["packages"].arrayValue ?? []
        
        if packagesArray.contains("favor_of_the_angel") {
            chance += 1
        }
        
        return "\(chance)%"
    }
    
    func getLevel(playerXP: Int) -> Double {
        let initialXP = [0.0, 20.0, 70.0, 150.0, 250.0, 500.0, 1000.0, 2000.0, 3500.0, 6000.0, 10000.0, 15000.0]
        let recurringXP = 10000.0
        
        var xp = Double(playerXP)
        
        if xp >= 15000 {
            return (xp - 15000) / recurringXP + 12
        } else {
            for (i, xpLevel) in initialXP.enumerated() {
                if xp < initialXP[i] {
                    return Double(i) + (xp - initialXP[i-1]) / (initialXP[i] - initialXP[i-1])
                }
            }
        }
        
        return 0.0
    }
    
    func getPrestige(level: Double) -> (String, UIColor) {
        
        let prestiges = [
            (level: 0,   color: UIColor(named: "mc_gray")!, name: "None"),
            (level: 5,   color: .label, name: "Iron"),
            (level: 10,  color: UIColor(named: "mc_gold")!, name: "Gold"),
            (level: 15,  color: UIColor(named: "mc_aqua")!, name: "Diamond"),
            (level: 20,  color: UIColor(named: "mc_dark_green")!, name: "Emerald"),
            (level: 25,  color: UIColor(named: "mc_dark_aqua")!, name: "Sapphire"),
            (level: 30,  color: UIColor(named: "mc_dark_red")!, name: "Ruby"),
            (level: 35,  color: UIColor(named: "mc_pink")!, name: "Crystal"),
            (level: 40,  color: UIColor(named: "mc_blue")!, name: "Opal"),
            (level: 45,  color: UIColor(named: "mc_dark_purple")!, name: "Amethyst"),
            //Clear color indicates it should be rainbow gradient
            (level: 50,  color: .clear, name: "Rainbow"),
            (level: 60, color: .clear, name: "Mythic"),
            (level: 100, color: .clear, name: "Mythic")
        ]
        
        let icons = [
            "default": "\u{22c6}",
            "angel_1": "\u{2605}",
            "angel_2": "\u{2606}",
            "angel_3": "\u{2055}",
            "angel_4": "\u{2736}",
            "angel_5": "\u{2733}",
            "angel_6": "\u{2734}",
            "angel_7": "\u{2737}",
            "angel_8": "\u{274b}",
            "angel_9": "\u{273c}",
            "angel_10": "\u{2742}",
            "angel_11": "\u{2741}",
            "angel_12": "\u{262c}",
            "iron_prestige": "\u{2719}",
            "gold_prestige": "\u{2764}",
            "diamond_prestige": "\u{2620}",
            "emerald_prestige": "\u{2726}",
            "sapphire_prestige": "\u{270c}\u{FE0E}",
            "ruby_prestige": "\u{2766}",
            "crystal_prestige": "\u{2735}",
            "opal_prestige": "\u{2763}",
            "amethyst_prestige": "\u{262f}",
            "rainbow_prestige": "\u{273a}",
            "mythic_prestige": "\u{0ca0}_\u{0ca0}",
            "favor_icon": "\u{2694}",
            "omega_icon": "\u{03a9}",
        ]
        
        var prestigeString = ""
        var color = UIColor.label
        
        for prestige in prestiges.reversed() {
            if Double(prestige.level) <= floor(level) {
                prestigeString += prestige.name
                color = prestige.color
                break
            }
        }
        
        var prestigeIcon = ""
        
        if data["selected_prestige_icon"].exists() {
            prestigeIcon = icons[data["selected_prestige_icon"].stringValue] ?? ""
        }
        
        prestigeString += " "
        prestigeString += prestigeIcon
        
        return (prestigeString, color)
    }
}
