//
//  OneTimeAchievement.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import Foundation


class OneTimeAchievement {
    
    var gameID: String
    var name: String
    var description: String
    var points: Int
    var gamePercentUnlocked: Double
    var globalPercentUnlocked: Double
    var isLegacy: Bool
    
    init(gameID: String = "", name: String = "", description: String = "", points: Int = 0, gamePercentUnlocked: Double = 0.0, globalPercentUnlocked: Double = 0.0, legacy: Bool = false) {
        self.gameID = gameID
        self.name = name
        self.description = description
        self.points = points
        self.gamePercentUnlocked = gamePercentUnlocked
        self.globalPercentUnlocked = globalPercentUnlocked
        self.isLegacy = legacy
    }
    
}
