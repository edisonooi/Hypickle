//
//  MinecraftUser.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import Foundation

class MinecraftUser {
    
    var username: String = ""
    var uuid: String = ""
    var skin: String = ""
    
    init(username: String, uuid: String) {
        self.username = username
        self.uuid = uuid
        self.skin = "https://crafatar.com/renders/body/\(self.uuid)?default=MHF_Steve&overlay=true"
        
    }
    
    
}
