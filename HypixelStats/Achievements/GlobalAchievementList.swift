//
//  GlobalAchievementList.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/21/21.
//

import Foundation
import SwiftyJSON

//All of the achievements for a particular gamemode
struct AchievementGroup {
    var gameID: String
    var totalCount: Int
    var totalPoints: Int
    var totalLegacyCount: Int
    var totalLegacyPoints: Int
    var oneTimeAchievements: [String: OneTimeAchievement]
    var tieredAchievements: [String: TieredAchievement]
    var legacyOneTimeAchievements: [String: OneTimeAchievement]
    var legacyTieredAchievements: [String: TieredAchievement]
    
}

class GlobalAchievementList {
    static let shared = GlobalAchievementList()
    
    var globalList: [String: AchievementGroup] = [:]
    
    var totalAchievementCount = 0
    var totalAchievementPoints = 0
    
    var totalLegacyCount = 0
    var totalLegacyPoints = 0
    
    
    func initializeGlobalList(data: JSON) {
        //Reset everything in case function is called again
        globalList.removeAll()
        totalAchievementCount = 0
        totalAchievementPoints = 0
        totalLegacyCount = 0
        totalLegacyPoints = 0
        
        
        for(key, value):(String, JSON) in data {
            let gameID = key
            var points = 0
            var count = 0
            var legacyPoints = 0
            var legacyCount = 0
            
            var oneTimes: [String: OneTimeAchievement] = [:]
            var legacyOneTimes: [String: OneTimeAchievement] = [:]
            
            for(name, achievement):(String, JSON) in value["one_time"] {
                let oneTimeAchievement = OneTimeAchievement(gameID: gameID,
                                                            name: achievement["name"].stringValue,
                                                            description: achievement["description"].stringValue,
                                                            points: achievement["points"].intValue,
                                                            gamePercentUnlocked: achievement["gamePercentUnlocked"].doubleValue,
                                                            globalPercentUnlocked: achievement["globalPercentUnlocked"].doubleValue,
                                                            legacy: achievement["legacy"].boolValue)
                
                points += oneTimeAchievement.points
                count += 1
                
                if !oneTimeAchievement.isLegacy {
                    totalAchievementCount += 1
                    totalAchievementPoints += oneTimeAchievement.points
                    
                    oneTimes[name] = oneTimeAchievement
                } else {
                    totalLegacyCount += 1
                    legacyCount += 1
                    legacyPoints += oneTimeAchievement.points
                    totalLegacyPoints += oneTimeAchievement.points
                    
                    legacyOneTimes[name] = oneTimeAchievement
                }
                
                
            }
            
            var tiered: [String: TieredAchievement] = [:]
            var legacyTiered: [String: TieredAchievement] = [:]
            
            for(name, achievement):(String, JSON) in value["tiered"] {
                let tieredAchievement = TieredAchievement(name: achievement["name"].stringValue,
                                                          description: achievement["description"].stringValue,
                                                          tiers: achievement["tiers"],
                                                          legacy: achievement["legacy"].boolValue)
                
                
                for tier in tieredAchievement.tiers {
                    points += tier.points
                    count += 1
                    
                    if !tieredAchievement.isLegacy {
                        totalAchievementPoints += tier.points
                        totalAchievementCount += 1
                        tiered[name] = tieredAchievement
                    } else {
                        totalLegacyCount += 1
                        legacyCount += 1
                        legacyPoints += tier.points
                        totalLegacyPoints += tier.points
                        legacyTiered[name] = tieredAchievement
                    }
                    
                }
                
                
                
            }
            
            globalList[gameID] = AchievementGroup(gameID: gameID,
                                                  totalCount: count,
                                                  totalPoints: points,
                                                  totalLegacyCount: legacyCount,
                                                  totalLegacyPoints: legacyPoints,
                                                  oneTimeAchievements: oneTimes,
                                                  tieredAchievements: tiered,
                                                  legacyOneTimeAchievements: legacyOneTimes,
                                                  legacyTieredAchievements: legacyTiered)
        }
        
        
    }
    
    
}
