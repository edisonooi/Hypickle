//
//  GameTypes.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/31/21.
//

import Foundation

class GameTypes {
        
    static let allGames = [
        "ARCADE": (databaseName: "Arcade", cleanName: "Arcade"),
        "BEDWARS": (databaseName: "Bedwars", cleanName: "Bedwars"),
        "BUILD_BATTLE": (databaseName: "BuildBattle", cleanName: "Build Battle"),
        "SURVIVAL_GAMES": (databaseName: "HungerGames", cleanName: "Blitz Survival Games"),
        "MCGO": (databaseName: "MCGO", cleanName: "Cops and Crims"),
        "DUELS": (databaseName: "Duels", cleanName: "Duels"),
        "WALLS3": (databaseName: "Walls3", cleanName: "Mega Walls"),
        "MURDER_MYSTERY": (databaseName: "MurderMystery", cleanName: "Murder Mystery"),
        "SKYWARS": (databaseName: "SkyWars", cleanName: "SkyWars"),
        "SUPER_SMASH": (databaseName: "SuperSmash", cleanName: "Smash Heroes"),
        "SPEED_UHC": (databaseName: "SpeedUHC", cleanName: "Speed UHC"),
        "TNTGAMES": (databaseName: "TNTGames", cleanName: "TNT Games"),
        "UHC": (databaseName: "UHC", cleanName: "UHC Champions"),
        "BATTLEGROUND": (databaseName: "Battleground", cleanName: "Warlords"),
        "ARENA": (databaseName: "Arena", cleanName: "Arena"),
        "PAINTBALL": (databaseName: "Paintball", cleanName: "Paintball"),
        "QUAKECRAFT": (databaseName: "Quake", cleanName: "Quake"),
        "GINGERBREAD": (databaseName: "GingerBread", cleanName: "Turbo Kart Racers"),
        "VAMPIREZ": (databaseName: "VampireZ", cleanName: "VampireZ"),
        "WALLS": (databaseName: "Walls", cleanName: "Walls"),
        "TRUE_COMBAT": (databaseName: "TrueCombat", cleanName: "Crazy Walls"),
        "SKYCLASH": (databaseName: "SkyClash", cleanName: "SkyClash")
    ]
    
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
    
    static let achievementGameIDToCleanName: [String: String] = [
        "general": "General",
        "housing": "Housing",
        
        "arcade": "Arcade",
        "arena": "Arena Brawl",
        "bedwars": "Bedwars",
        "blitz": "Blitz Survival Games",
        "buildbattle": "Build Battle",
        "copsandcrims": "Cops and Crims",
        "duels": "Duels",
        "walls3": "Mega Walls",
        "murdermystery": "Murder Mystery",
        "paintball": "Paintball",
        "pit": "Pit",
        "quake": "QuakeCraft",
        "skyblock": "SkyBlock",
        "skywars": "SkyWars",
        "supersmash": "Smash Heroes",
        "speeduhc": "Speed UHC",
        "tntgames": "TNT Games",
        "gingerbread": "Turbo Kart Racers",
        "uhc": "UHC Champions",
        "vampirez": "VampireZ",
        "walls": "Walls",
        "warlords": "Warlords",
        
        "christmas2017": "Christmas",
        "easter": "Easter",
        "halloween2017": "Halloween",
        "summer": "Summer",
        
        "truecombat": "Crazy Walls",
        "skyclash": "SkyClash"
    ]
    
    static let achievementGameIDToDatabaseName: [String: String] = [
        "general": "General",
        "housing": "Housing",
        
        "arcade": "Arcade",
        "arena": "Arena",
        "bedwars": "Bedwars",
        "blitz": "HungerGames",
        "buildbattle": "BuildBattle",
        "copsandcrims": "MCGO",
        "duels": "Duels",
        "walls3": "Walls3",
        "murdermystery": "MurderMystery",
        "paintball": "Paintball",
        "pit": "Pit",
        "quake": "Quake",
        "skyblock": "SkyBlock",
        "skywars": "SkyWars",
        "supersmash": "SuperSmash",
        "speeduhc": "SpeedUHC",
        "tntgames": "TNTGames",
        "gingerbread": "Gingerbread",
        "uhc": "UHC",
        "vampirez": "VampireZ",
        "walls": "Walls",
        "warlords": "Battleground",
        
        "christmas2017": "grinch_simulator",
        "easter": "easter_simulator",
        "halloween2017": "halloween_simulator",
        "summer": "scuba_simulator",
        
        "truecombat": "TrueCombat",
        "skyclash": "SkyClash"
    ]
    
    
}
