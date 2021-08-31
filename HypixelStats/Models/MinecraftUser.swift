//
//  MinecraftUser.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import Foundation
import SwiftyJSON

class MinecraftUser {
    
    var username: String
    var uuid: String
    var skin: String
    var playerHypixelData: JSON
    var isOnline: Bool = false
    var gameType: String = "-"
    
    init(username: String, uuid: String) {
        self.username = username
        self.uuid = uuid
        self.skin = "https://crafatar.com/renders/body/\(self.uuid)?default=MHF_Steve&overlay=true"
        self.playerHypixelData = [:]
    }
    
    
}
