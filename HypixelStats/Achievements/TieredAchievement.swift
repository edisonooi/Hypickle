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
    var isLegacy: Bool
    var tiers: [AchievementTier] = []
    
    init(name: String, description: String, tiers: JSON, legacy: Bool = false) {
        self.name = name
        self.description = description
        self.isLegacy = legacy
        
        for (_, subJSON):(String, JSON) in tiers {
            self.tiers.append(AchievementTier(
                                tier: subJSON["tier"].intValue,
                                points: subJSON["points"].intValue,
                                amount: subJSON["amount"].intValue))
        }
    }
    
}
