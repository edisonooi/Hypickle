//
//  OneTimeAchievement.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import Foundation


class OneTimeAchievement {
    
    var name: String
    var description: String
    var points: Int
    var gamePercentUnlocked: Double
    var globalPercentUnlocked: Double
    var legacy: Bool
    
    init(name: String, description: String, points: Int, gamePercentUnlocked: Double = 0.0, globalPercentUnlocked: Double, legacy: Bool = false) {
        self.name = name
        self.description = description
        self.points = points
        self.gamePercentUnlocked = gamePercentUnlocked
        self.globalPercentUnlocked = globalPercentUnlocked
        self.legacy = legacy
    }
    
}
