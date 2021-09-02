//
//  MinecraftUser.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import Foundation
import SwiftyJSON

class MinecraftUser {
    
    var username: String = ""
    var uuid: String = ""
    var skin: String = ""
    var playerHypixelData: JSON = [:]
    var isOnline: Bool = false
    var gameType: String = "-"
    
    //Singleton instance that contains all the info for the user that was searched
    static let shared = MinecraftUser()
    
    
}
