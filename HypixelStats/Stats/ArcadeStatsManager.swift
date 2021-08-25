//
//  ArcadeStatsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/14/21.
//

import Foundation
import UIKit
import SwiftyJSON

class ArcadeStatsManager: NSObject, StatsManager {
    
    var data: JSON = [:]
    var achievementsData: JSON = [:]
    
    init(data: JSON, achievementsData: JSON) {
        self.data = data
        self.achievementsData = achievementsData
    }
    
    let headers = [
        0: (image: "blocking_dead_icon", title: "Blocking Dead"),
        3: (image: "murdermystery_icon", title: "Bounty Hunters"),
        7: (image: "capture_the_wool_icon", title: "Capture the Wool"),
        9: (image: "creeper_attack_icon", title: "Creeper Attack"),
        10: (image: "dragon_wars_icon", title: "Dragon Wars"),
        12: (image: "ender_spleef_icon", title: "Ender Spleef"),
        13: (image: "farm_hunt_icon", title: "Farm Hunt"),
        15: (image: "football_icon", title: "Football"),
        19: (image: "quake_icon", title: "Galaxy Wars"),
        26: (image: "hide_and_seek_icon", title: "Hide and Seek"),
        28: (image: "hole_in_the_wall_icon", title: "Hole in the Wall"),
        31: (image: "hypixel_says_icon", title: "Hypixel Says"),
        
        32: (image: "mini_walls_icon", title: "Mini Walls"),
        33: (image: "", title: ""),
        38: (image: "", title: ""),
        
        41: (image: "party_games_icon", title: "Party Games"),
        44: (image: "pixel_painters_icon", title: "Pixel Painters"),
        45: (image: "paintball_icon", title: "Throw Out"),
        
        49: (image: "zombies_icon", title: "Zombies"),
        51: (image: "", title: ""),
        53: (image: "", title: ""),
        58: (image: "", title: ""),
        60: (image: "", title: ""),
        62: (image: "", title: "Maps"),
        65: (image: "", title: "Zombie Types"),
        
        66: (image: "easter_simulator_icon", title: "Easter Simulator"),
        68: (image: "grinch_simulator_icon", title: "Grinch Simulator v2"),
        70: (image: "halloween_simulator_icon", title: "Halloween Simulator"),
        72: (image: "santa_says_icon", title: "Santa Says"),
        73: (image: "santa_says_icon", title: "Santa Simulator"),
        75: (image: "scuba_simulator_icon", title: "Scuba Simulator")
    ]
    
    lazy var statsTableData: [CellData] = {
        
        var ret: [CellData] = []
        
        var blockingDeadStats = [
            CellData(headerData: ("Wins", data["wins_dayone"].intValue), sectionData: []),
            CellData(headerData: ("Kills", data["kills_dayone"].intValue), sectionData: []),
            CellData(headerData: ("Headshots", data["headshots_dayone"].intValue), sectionData: [])
        ]
        
        var bountyHuntersStats = [
            CellData(headerData: ("Wins", data["wins_oneinthequiver"].intValue), sectionData: []),
            CellData(headerData: ("Kills", data["kills_oneinthequiver"].intValue), sectionData: []),
            CellData(headerData: ("Deaths", data["deaths_oneinthequiver"].intValue), sectionData: []),
            CellData(headerData: ("K/D", Utils.calculateRatio(numerator: data["kills_oneinthequiver"].intValue, denominator: data["deaths_oneinthequiver"].intValue)), sectionData: [])
        ]
        
        var captureTheWoolStats = [
            CellData(headerData: ("Kills", achievementsData["arcade_ctw_slayer"].intValue), sectionData: []),
            CellData(headerData: ("Wool Captures", achievementsData["arcade_ctw_oh_sheep"].intValue), sectionData: [])
        ]
        
        var creeperAttackStats = [
            CellData(headerData: ("Highest Wave", data["max_wave"].intValue), sectionData: [])
        ]
        
        var dragonWarsStats = [
            CellData(headerData: ("Wins", data["wins_dragonwars2"].intValue), sectionData: []),
            CellData(headerData: ("Kills", data["kills_dragonwars2"].intValue), sectionData: [])
        ]
        
        var enderSpleefStats = [
            CellData(headerData: ("Wins", data["wins_ender"].intValue), sectionData: [])
        ]
        
        var farmHuntStats = [
            CellData(headerData: ("Wins", data["wins_farm_hunt"].intValue), sectionData: []),
            CellData(headerData: ("Poop Collected", data["poop_collected"].intValue), sectionData: [])
        ]
        
        var footballStats = [
            CellData(headerData: ("Wins", data["wins_soccer"].intValue), sectionData: []),
            CellData(headerData: ("Goals", data["goals_soccer"].intValue), sectionData: []),
            CellData(headerData: ("Kicks", data["kicks_soccer"].intValue), sectionData: []),
            CellData(headerData: ("Power Kicks", data["powerkicks_soccer"].intValue), sectionData: [])
        ]
        
        var galaxyWarsStats = [
            CellData(headerData: ("Wins", data["sw_game_wins"].intValue), sectionData: []),
            CellData(headerData: ("Kills", data["sw_kills"].intValue), sectionData: []),
            CellData(headerData: ("Empire Kills", data["sw_empire_kills"].intValue), sectionData: []),
            CellData(headerData: ("Rebel Kills", data["sw_rebel_kills"].intValue), sectionData: []),
            CellData(headerData: ("Deaths", data["sw_deaths"].intValue), sectionData: []),
            CellData(headerData: ("K/D", Utils.calculateRatio(numerator: data["sw_kills"].intValue, denominator: data["sw_deaths"].intValue)), sectionData: []),
            CellData(headerData: ("Shots Fired", data["sw_shots_fired"].intValue), sectionData: [])
        ]
        
        var hideAndSeekStats = [
            CellData(headerData: ("Seeker Wins", data["seeker_wins_hide_and_seek"].intValue), sectionData: []),
            CellData(headerData: ("Hider Wins", data["hider_wins_hide_and_seek"].intValue), sectionData: [])
        ]
        
        var holeInTheWallStats = [
            CellData(headerData: ("Wins", data["wins_hole_in_the_wall"].intValue), sectionData: []),
            CellData(headerData: ("Highest Score Qualifications", data["hitw_record_q"].intValue), sectionData: []),
            CellData(headerData: ("Highest Score Finals", data["hitw_record_f"].intValue), sectionData: [])
        ]
        
        var hypixelSaysStats = [
            CellData(headerData: ("Wins", data["wins_simon_says"].intValue), sectionData: [])
        ]
        
        var miniWallsStats = [
            CellData(headerData: ("Wins", data["wins_mini_walls"].intValue), sectionData: []),
            
            CellData(headerData: ("Kills", data["kills_mini_walls"].intValue), sectionData: []),
            CellData(headerData: ("Final Kills", data["final_kills_mini_walls"].intValue), sectionData: []),
            CellData(headerData: ("Deaths", data["deaths_mini_walls"].intValue), sectionData: []),
            CellData(headerData: ("K/D", Utils.calculateRatio(numerator: data["kills_mini_walls"].intValue + data["final_kills_mini_walls"].intValue, denominator: data["deaths_mini_walls"].intValue)), sectionData: []),
            
            CellData(headerData: ("Withers Killed", data["wither_kills_mini_walls"].intValue), sectionData: []),
            
            CellData(headerData: ("Arrows Shot", data["arrows_shot_mini_walls"].intValue), sectionData: []),
            CellData(headerData: ("Arrows Hit", data["arrows_hit_mini_walls"].intValue), sectionData: []),
            CellData(headerData: ("Arrow Accuracy", Utils.calculatePercentage(numerator: data["arrows_hit_mini_walls"].intValue, denominator: data["arrows_shot_mini_walls"].intValue)), sectionData: [])
        ]
        
        var partyGamesStats = [
            CellData(headerData: ("Wins Party Games 1", data["wins_party"].intValue), sectionData: []),
            CellData(headerData: ("Wins Party Games 2", data["wins_party_2"].intValue), sectionData: []),
            CellData(headerData: ("Wins Party Games 3", data["wins_party_3"].intValue), sectionData: [])
        ]
        
        var pixelPaintersStats = [
            CellData(headerData: ("Wins", data["wins_draw_their_thing"].intValue), sectionData: [])
        ]
        
        var throwOutStats = [
            CellData(headerData: ("Wins", data["wins_throw_out"].intValue), sectionData: []),
            CellData(headerData: ("Kills", data["kills_throw_out"].intValue), sectionData: []),
            CellData(headerData: ("Deaths", data["deaths_throw_out"].intValue), sectionData: []),
            CellData(headerData: ("K/D", Utils.calculateRatio(numerator: data["kills_throw_out"].intValue, denominator: data["deaths_throw_out"].intValue)), sectionData: [])
        ]
        
        var zombiesStats = getZombiesStats()
        
        var easterSimulatorStats = [
            CellData(headerData: ("Wins", data["wins_easter_simulator"].intValue), sectionData: []),
            CellData(headerData: ("Eggs Found", data["eggs_found_easter_simulator"].intValue), sectionData: [])
        ]
        
        var grinchSimulatorV2Stats = [
            CellData(headerData: ("Wins", data["wins_grinch_simulator_v2"].intValue), sectionData: []),
            CellData(headerData: ("Presents Stolen", data["gifts_grinch_simulator_v2"].intValue), sectionData: [])
        ]
        
        var halloweenSimulatorStats = [
            CellData(headerData: ("Wins", data["wins_halloween_simulator"].intValue), sectionData: []),
            CellData(headerData: ("Candy Found", data["candy_found_halloween_simulator"].intValue), sectionData: [])
        ]
        
        var santaSaysStats = [
            CellData(headerData: ("Wins", data["wins_santa_says"].intValue), sectionData: [])
        ]
        
        var santaSimulatorStats = [
            CellData(headerData: ("Presents Delivered", data["delivered_santa_simulator"].intValue), sectionData: []),
            CellData(headerData: ("Times Spotted", data["spotted_santa_simulator"].intValue), sectionData: [])
        ]
        
        var scubaSimulatorStats = [
            CellData(headerData: ("Wins", data["wins_scuba_simulator"].intValue), sectionData: []),
            CellData(headerData: ("Items Found", data["items_found_scuba_simulator"].intValue), sectionData: []),
            CellData(headerData: ("Total Points", data["total_points_scuba_simulator"].intValue), sectionData: [])
        ]
        
        ret.append(contentsOf: blockingDeadStats)
        ret.append(contentsOf: bountyHuntersStats)
        ret.append(contentsOf: captureTheWoolStats)
        ret.append(contentsOf: creeperAttackStats)
        ret.append(contentsOf: dragonWarsStats)
        ret.append(contentsOf: enderSpleefStats)
        ret.append(contentsOf: farmHuntStats)
        ret.append(contentsOf: footballStats)
        ret.append(contentsOf: galaxyWarsStats)
        ret.append(contentsOf: hideAndSeekStats)
        ret.append(contentsOf: holeInTheWallStats)
        ret.append(contentsOf: hypixelSaysStats)
        ret.append(contentsOf: miniWallsStats)
        ret.append(contentsOf: partyGamesStats)
        ret.append(contentsOf: pixelPaintersStats)
        ret.append(contentsOf: throwOutStats)
        ret.append(contentsOf: zombiesStats)
        
        ret.append(contentsOf: easterSimulatorStats)
        ret.append(contentsOf: grinchSimulatorV2Stats)
        ret.append(contentsOf: halloweenSimulatorStats)
        ret.append(contentsOf: santaSaysStats)
        ret.append(contentsOf: santaSimulatorStats)
        ret.append(contentsOf: scubaSimulatorStats)
        
        return ret
    }()
    
    func getZombiesStats() -> [CellData] {
        var ret: [CellData] = []
        
        var generalStats = [
            CellData(headerData: ("Wins", data["wins_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Zombies Killed", data["zombie_kills_zombies"].intValue), sectionData: []),
            
            CellData(headerData: ("Best Round", data["best_round_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Total Rounds Survived", data["total_rounds_survived_zombies"].intValue), sectionData: []),
            
            CellData(headerData: ("Bullets Shot", data["bullets_shot_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Bullets Hit", data["bullets_hit_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Bullet Accuracy", Utils.calculatePercentage(numerator: data["bullets_hit_zombies"].intValue, denominator: data["bullets_shot_zombies"].intValue)), sectionData: []),
            CellData(headerData: ("Headshots", data["headshots_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Headshot Percentage", Utils.calculatePercentage(numerator: data["headshots_zombies"].intValue, denominator: data["bullets_hit_zombies"].intValue)), sectionData: []),
            
            CellData(headerData: ("Players Revived", data["players_revived_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Times Knocked Down", data["times_knocked_down_zombies"].intValue), sectionData: []),
            
            CellData(headerData: ("Doors Opened", data["doors_opened_zombies"].intValue), sectionData: []),
            CellData(headerData: ("Windows Repaired Killed", data["windows_repaired_zombies"].intValue), sectionData: [])
        ]
        
        ret.append(contentsOf: generalStats)
        
        let maps = [
            (id: "deadend", name: "Dead End", color: "gold"),
            (id: "badblood", name: "Bad Blood", color: "red"),
            (id: "alienarcadium", name: "Alien Arcadium", color: "pink"),
        ]
        
        let desiredMapStats = ["Wins", "Best Round", "Zombies Killed", "Deaths", "Timed Knocked Down", "Players Revived", "Doors Opened", "Windows Repaired"]
        
        var mapStats: [CellData] = []
    
        for map in maps {
            var statsForThisMap: [(String, Any)] = []
            
            let mapWins = data["wins_zombies_" + map.id].intValue
            let mapBestRound = data["best_round_zombies_" + map.id].intValue
            
            let mapKills = data["zombie_kills_zombies_" + map.id].intValue
            let mapDeaths = data["deaths_zombies_" + map.id].intValue
            
            let mapKnocked = data["times_knocked_down_zombies_" + map.id].intValue
            let mapRevives = data["players_revived_zombies_" + map.id].intValue
            
            let mapDoorsOpened = data["doors_opened_zombies_" + map.id].intValue
            let mapWindowsRepaired = data["windows_repaired_zombies_" + map.id].intValue
            
            let dataForThisMap = [mapWins, mapBestRound, mapKills, mapDeaths, mapKnocked, mapRevives, mapDoorsOpened, mapWindowsRepaired]
            
            for (index, category) in desiredMapStats.enumerated() {
                statsForThisMap.append((category, dataForThisMap[index]))
            }
            
            mapStats.append(CellData(headerData: (map.name, ""), sectionData: statsForThisMap))
        }
        
        ret.append(contentsOf: mapStats)
        
        var zombieTypes = [
            (id: "basic", name: "Basic"),
            (id: "blaze", name: "Blaze"),
            (id: "empowered", name: "Empowered"),
            (id: "ender", name: "Ender"),
            (id: "endermite", name: "Endermite"),
            (id: "fire", name: "Fire"),
            (id: "guardian", name: "Guardian"),
            (id: "magma", name: "Magma"),
            (id: "magma_cube", name: "Magma Cube"),
            (id: "pig_zombie", name: "Pig Zombie"),
            (id: "skelefish", name: "Skelefish"),
            (id: "tnt_baby", name: "TNT Baby"),
            (id: "tnt", name: "Bombie"),
            (id: "broodmother", name: "Broodmother"),
            (id: "king_slime", name: "King Slime"),
            (id: "wither", name: "Wither"),
            (id: "herobrine", name: "Herobrine"),
            (id: "mega_blob", name: "Mega Blob"),
            (id: "mega_magma", name: "Mega Magma"),
            (id: "world_ender", name: "World Ender"),
            (id: "silverfish", name: "Silverfish"),
            (id: "rainbow", name: "Rainbow"),
            (id: "giant", name: "Giant"),
            (id: "space_blaster", name: "Space Blaster"),
            (id: "chgluglu", name: "Chgluglu"),
            (id: "ghast", name: "Ghast"),
            (id: "worm_small", name: "Worm Small"),
            (id: "worm", name: "Worm"),
            (id: "sentinel", name: "Sentinel"),
            (id: "skeleton", name: "Skeleton"),
            (id: "space_grunt", name: "Space Grunt"),
            (id: "clown", name: "Clown"),
            (id: "blob", name: "Blob"),
            (id: "iron_golem", name: "Iron Golem"),
            (id: "inferno", name: "Inferno"),
            (id: "tnt", name: "TNT"),
            (id: "werewolf", name: "Werewolf"),
            (id: "wither_skeleton", name: "Wither Skeleton"),
            (id: "cave_spider", name: "Cave Spider"),
            (id: "invisible", name: "Invisible"),
            (id: "creper", name: "Creper"),
            (id: "family_twin_blue", name: "Family Twin Blue"),
            (id: "charged_creeper", name: "Charged Creeper"),
            (id: "herobrine_minion", name: "Herobrine Minion"),
            (id: "the_old_one", name: "The Old One"),
            (id: "wolf_pet", name: "Wolf Pet"),
            (id: "family_twin_red", name: "Family Twin Red"),
            (id: "slime", name: "Slime"),
            (id: "wolf", name: "Wolf"),
            (id: "witch", name: "Witch"),
            (id: "slime_zombie", name: "Slime Zombie")
        ]
        
        zombieTypes.sort {
            $0.name < $1.name
        }
        
        var typeStats: [(String, Any)] = [("TYPE", "KILLS")]
        
        for zombie in zombieTypes {
            if data[zombie.id + "_zombie_kills_zombies"].exists() {
                typeStats.append((zombie.name, data[zombie.id + "_zombie_kills_zombies"].intValue))
            }
        }
        
        ret.append(CellData(headerData: ("Zombie Stats", ""), sectionData: typeStats))
        
        return ret
    }
    
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
