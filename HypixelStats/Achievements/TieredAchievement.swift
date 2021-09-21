//
//  TieredAchievement.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import Foundation
import SwiftyJSON

struct AchievementTier {
    var tier: Int
    var points: Int
    var amount: Int
}

class TieredAchievement {
    
    var name: String
    var description: String
    var tiers: [AchievementTier] = []
    
    init(name: String, description: String, tiers: JSON) {
        self.name = name
        self.description = description.replacingOccurrences(of: "\\u0027", with: "'")
        
        for (_, subJSON):(String, JSON) in tiers {
            self.tiers.append(AchievementTier(
                                tier: subJSON["tier"].intValue,
                                points: subJSON["points"].intValue,
                                amount: subJSON["amount"].intValue))
        }
    }
    
}