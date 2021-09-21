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
    
    init(name: String, description: String, points: Int, gamePercentUnlocked: Double = 0.0, globalPercentUnlocked: Double) {
        self.name = name
        self.description = description.replacingOccurrences(of: "\\u0027", with: "'")
        self.points = points
        self.gamePercentUnlocked = gamePercentUnlocked
        self.globalPercentUnlocked = globalPercentUnlocked
    }
    
}
