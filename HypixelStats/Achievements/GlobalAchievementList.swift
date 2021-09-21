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
    var oneTimeAchievements: [String: OneTimeAchievement]
    var tieredAchievements: [String: TieredAchievement]
}

class GlobalAchievementList {
    static var globalList: [String: AchievementGroup] = [:]
    
    static func initializeGlobalList(data: JSON) {
        for(key, value):(String, JSON) in data {
            let gameID = key
            
            var oneTimes: [String: OneTimeAchievement] = [:]
            for(name, achievement):(String, JSON) in value["one_time"] {
                let oneTimeAchievement = OneTimeAchievement(name: achievement["name"].stringValue,
                                                            description: achievement["description"].stringValue,
                                                            points: achievement["points"].intValue,
                                                            gamePercentUnlocked: achievement["gamePercentUnlocked"].doubleValue,
                                                            globalPercentUnlocked: achievement["globalPercentUnlocked"].doubleValue)
                
                oneTimes[name] = oneTimeAchievement
            }
            
            var tiered: [String: TieredAchievement] = [:]
            for(name, achievement):(String, JSON) in value["tiered"] {
                let tieredAchievement = TieredAchievement(name: achievement["name"].stringValue,
                                                          description: achievement["description"].stringValue,
                                                          tiers: achievement["tiers"])
                
                tiered[name] = tieredAchievement
            }
            
            GlobalAchievementList.globalList[gameID] = AchievementGroup(gameID: gameID, oneTimeAchievements: oneTimes, tieredAchievements: tiered)
        }
    }
    
    
}
