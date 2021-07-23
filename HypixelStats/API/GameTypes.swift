//
//  GameTypes.swift
//  HypixelStats
//
//  Created by codeplus on 7/19/21.
//

import Foundation

class GameTypes {
    
    struct game {
        var typeName: String
        var databaseName: String
        var cleanName: String
    }
    
//    This list is missing Pit
//    static let allGames: [game] = [
//        game(typeName: "ARCADE", databaseName: "Arcade", cleanName: "Arcade"),
//        game(typeName: "BEDWARS", databaseName: "Bedwars", cleanName: "Bedwars"),
//        game(typeName: "BUILD_BATTLE", databaseName: "BuildBattle", cleanName: "Build Battle"),
//        game(typeName: "SURVIVAL_GAMES", databaseName: "HungerGames", cleanName: "Blitz Survival Games"),
//        game(typeName: "MCGO", databaseName: "MCGO", cleanName: "Cops and Crims"),
//        game(typeName: "DUELS", databaseName: "Duels", cleanName: "Duels"),
//        game(typeName: "WALLS3", databaseName: "Walls3", cleanName: "Mega Walls"),
//        game(typeName: "MURDER_MYSTERY", databaseName: "MurderMystery", cleanName: "Murder Mystery"),
//        game(typeName: "SKYWARS", databaseName: "SkyWars", cleanName: "SkyWars"),
//        game(typeName: "SUPER_SMASH", databaseName: "SuperSmash", cleanName: "Smash Heroes"),
//        game(typeName: "SPEED_UHC", databaseName: "SpeedUHC", cleanName: "Speed UHC"),
//        game(typeName: "TNTGAMES", databaseName: "TNTGames", cleanName: "TNT Games"),
//        game(typeName: "UHC", databaseName: "UHC", cleanName: "UHC Champions"),
//        game(typeName: "BATTLEGROUND", databaseName: "Battleground", cleanName: "Warlords"),
//        game(typeName: "ARENA", databaseName: "Arena", cleanName: "Arena"),
//        game(typeName: "PAINTBALL", databaseName: "Paintball", cleanName: "Paintball"),
//        game(typeName: "QUAKECRAFT", databaseName: "Quake", cleanName: "Quake"),
//        game(typeName: "GINGERBREAD", databaseName: "GingerBread", cleanName: "Turbo Kart Racers"),
//        game(typeName: "VAMPIREZ", databaseName: "VampireZ", cleanName: "VampireZ"),
//        game(typeName: "WALLS", databaseName: "Walls", cleanName: "Walls"),
//        game(typeName: "TRUE_COMBAT", databaseName: "TrueCombat", cleanName: "Crazy Walls"),
//        game(typeName: "SKYCLASH", databaseName: "SkyClash", cleanName: "SkyClash")
//    ]
    
    static func calculateKDR(kills: Int, deaths: Int) -> String {
        
        let kills2 = Double(kills)
        let deaths2 = Double(deaths)
        var kdr = 0.0
        
        if kills2 == 0.0 && deaths2 == 0.0 {
            kdr = 0.0
        } else if kills2 != 0.0 && deaths2 == 0.0 {
            kdr = kills2
        } else {
            kdr = kills2 / deaths2
        }
        
        return String(format: "%.2f", kdr)
    }
    
    static let databaseNameToCleanName: [String: String] = [
        "Arcade": "Arcade",
        "Bedwars": "Bedwars",
        "BuildBattle": "Build Battle",
        "HungerGames": "Blitz Survival Games",
        "MCGO": "Cops and Crims",
        "Duels": "Duels",
        "Walls3": "Mega Walls",
        "MurderMystery": "Murder Mystery",
        "Pit": "Pit",
        "SkyWars": "SkyWars",
        "SuperSmash": "Smash Heroes",
        "SpeedUHC": "Speed UHC",
        "TNTGames": "TNT Games",
        "UHC": "UHC Champions",
        "Battleground": "Warlords",
        "Arena": "Arena Brawl",
        "Paintball": "Paintball",
        "Quake": "Quakecraft",
        "GingerBread": "Turbo Kart Racers",
        "VampireZ": "VampireZ",
        "Walls": "Walls",
        "TrueCombat": "Crazy Walls",
        "SkyClash": "SkyClash"
    ]
    
    static let desiredGameData: [String: [(String, Any)]] = [
        "Arcade": [
            
        ]
    ]
}
