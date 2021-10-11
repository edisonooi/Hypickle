//
//  AchievementsManager.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/22/21.
//

import Foundation
import SwiftyJSON

//Info on every completed achievement by a player for a particular game
struct CompletedAchievementGroup {
    var completedCount: Int
    var completedPoints: Int
    var oneTimesCompleted: Set<String> //Raw database name all caps
    var tieredCompletions: [String: (Int, Int)] //achievementName in caps: (tiersCompleted, completedAmount)
    var legacyOneTimesCompleted: Set<String>
    var legacyTieredCompletions: [String: (Int, Int)]
    var legacyCompletedCount: Int
    var legacyCompletedPoints: Int
}

class AchievementsManager {
    
    static let numRecentAchievements = 15
    static let numEasiestAchievements = 15
    
    static func getCompletedAchievements(data: JSON) -> (allCompletedAchievements: [String: CompletedAchievementGroup], recentlyCompletedAchievements: [OneTimeAchievement], incompleteOneTimes: [OneTimeAchievement]) {
        var ret: [String: CompletedAchievementGroup] = [:]
        var ret2 = [OneTimeAchievement](repeating: OneTimeAchievement(), count: numRecentAchievements)
        var ret3: [OneTimeAchievement] = []
        
        let oneTimesCompletedArray = data["achievementsOneTime"].arrayValue.map { $0.stringValue }
        
        var recentlyCompleted = Array(oneTimesCompletedArray.suffix(numRecentAchievements))
        recentlyCompleted = recentlyCompleted.reversed()
        
        let allOneTimesCompleted: Set = Set(oneTimesCompletedArray)
        
        let tieredCompletionsDictionary = data["achievements"].dictionaryValue
        var tieredCompletions: [String: Int] = [:]
        
        for (name, amount) in tieredCompletionsDictionary {
            tieredCompletions[name] = amount.intValue
        }
        
        for (gameID, _) in GameTypes.achievementGameIDToCleanName {
            var oneTimesCompleted: Set = Set<String>()
            var tieredCompleted: [String: (Int, Int)] = [:]
            
            var legacyOneTimesCompleted: Set = Set<String>()
            var legacyTieredCompleted: [String: (Int, Int)] = [:]
            
            var count = 0
            var points = 0
            
            var legacyCount = 0
            var legacyPoints = 0
            
            if let group = GlobalAchievementList.shared.globalList[gameID] {
                for (name, achievement) in group.oneTimeAchievements {
                    if allOneTimesCompleted.contains(gameID + "_" + name.lowercased()) {
                        if achievement.isLegacy {
                            legacyOneTimesCompleted.insert(name)
                            legacyCount += 1
                            legacyPoints += achievement.points
                        } else {
                            oneTimesCompleted.insert(name)
                            count += 1
                            points += achievement.points
                        }
                        
                        if recentlyCompleted.contains(gameID + "_" + name.lowercased()) {
                            if let index = recentlyCompleted.firstIndex(of: gameID + "_" + name.lowercased()) {
                                ret2[index] = achievement
                            }
                        }
                    } else {
                        if !achievement.isLegacy {
                            ret3.append(achievement)
                        }
                        
                    }
                }
                
                for(name, achievement) in group.tieredAchievements {
                    if let completedAmount = tieredCompletions[gameID + "_" + name.lowercased()] {
                        var tiersCompleted = 0
                        
                        for tier in achievement.tiers {
                            if completedAmount >= tier.amount {
                                tiersCompleted += 1
                                
                                if achievement.isLegacy {
                                    legacyCount += 1
                                    legacyPoints += tier.points
                                } else {
                                    count += 1
                                    points += tier.points
                                }
                                
                            } else {
                                break
                            }
                        }
                        
                        if achievement.isLegacy {
                            legacyTieredCompleted[name] = (tiersCompleted, completedAmount)
                        } else {
                            tieredCompleted[name] = (tiersCompleted, completedAmount)
                        }
                        
                        
                    }
                }
                
                ret[gameID] = CompletedAchievementGroup(completedCount: count,
                                                        completedPoints: points,
                                                        oneTimesCompleted: oneTimesCompleted,
                                                        tieredCompletions: tieredCompleted,
                                                        legacyOneTimesCompleted: legacyOneTimesCompleted,
                                                        legacyTieredCompletions: legacyTieredCompleted,
                                                        legacyCompletedCount: legacyCount,
                                                        legacyCompletedPoints: legacyPoints)
                print(gameID)
                print(points)
                print(legacyPoints)
                
            }
        }
        
        ret3.sort {
            $0.globalPercentUnlocked > $1.globalPercentUnlocked
        }
        
        return (allCompletedAchievements: ret, recentlyCompletedAchievements: ret2, incompleteOneTimes: ret3)
    }
}
