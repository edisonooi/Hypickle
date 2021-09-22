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
    var oneTimeAchievements: [String: OneTimeAchievement]
    var tieredAchievements: [String: TieredAchievement]
}

class GlobalAchievementList {
    static var globalList: [String: AchievementGroup] = [:]
    
    static var totalAchievementCount = 0
    static var totalAchievementPoints = 0
    
    static var totalLegacyCount = 0
    static var totalLegacyPoints = 0
    
    
    static func initializeGlobalList(data: JSON) {
        //Reset everything in case function is called again
        GlobalAchievementList.globalList.removeAll()
        totalAchievementCount = 0
        totalAchievementPoints = 0
        totalLegacyCount = 0
        totalLegacyPoints = 0
        
        
        for(key, value):(String, JSON) in data {
            let gameID = key
            var points = 0
            var count = 0
            
            var oneTimes: [String: OneTimeAchievement] = [:]
            for(name, achievement):(String, JSON) in value["one_time"] {
                let oneTimeAchievement = OneTimeAchievement(name: achievement["name"].stringValue,
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
                } else {
                    totalLegacyCount += 1
                    totalLegacyPoints += oneTimeAchievement.points
                }
                
                oneTimes[name] = oneTimeAchievement
            }
            
            var tiered: [String: TieredAchievement] = [:]
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
                    } else {
                        totalLegacyCount += 1
                        totalLegacyPoints += tier.points
                    }
                    
                }
                
                
                tiered[name] = tieredAchievement
            }
            
            GlobalAchievementList.globalList[gameID] = AchievementGroup(gameID: gameID, totalCount: count, totalPoints: points, oneTimeAchievements: oneTimes, tieredAchievements: tiered)
        }
        
        
    }
    
    
}
