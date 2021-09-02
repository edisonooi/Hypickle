//
//  RankManager.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/30/21.
//

import Foundation
import UIKit
import SwiftyJSON

class RankManager {
    
    static let colors: [String: UIColor] = [
        "DARK_BLUE" : UIColor(named: "mc_dark_blue")!,
        "DARK_GREEN" : UIColor(named: "mc_dark_green")!,
        "DARK_AQUA" : UIColor(named: "mc_dark_aqua")!,
        "DARK_RED" : UIColor(named: "mc_dark_red")!,
        "DARK_PURPLE" : UIColor(named: "mc_dark_purple")!,
        "GOLD" : UIColor(named: "mc_gold")!,
        "GRAY" : UIColor(named: "mc_gray")!,
        "DARK_GRAY" : UIColor(named: "mc_dark_gray")!,
        "BLUE" : UIColor(named: "mc_blue")!,
        "GREEN" : UIColor(named: "mc_green")!,
        "AQUA" : UIColor(named: "mc_aqua")!,
        "RED" : UIColor(named: "mc_red")!,
        "LIGHT_PURPLE" : UIColor(named: "mc_light_purple")!,
        "YELLOW" : UIColor(named: "mc_yellow")!,
        "WHITE" : UIColor(named: "white_label")!
    ]
    
    static func getRank(data: JSON) -> String {
        let possibleRanks = [
            data["rank"].stringValue,
            data["monthlyPackageRank"].stringValue,
            data["newPackageRank"].stringValue,
            data["packageRank"].stringValue
        ]
        
        var userRank = "NONE"
        
        for rank in possibleRanks {
            if rank != "" && rank != "NONE" && rank != "NORMAL" {
                userRank = rank
                break
            }
        }
        
        return userRank
    }
    
    static func getAttributedStringForRank(data: JSON) -> NSMutableAttributedString {
        
        let username = MinecraftUser.shared.username
        
        //TODO: Get custom ranks from data["prefix"]
        
        let ranks = [
            "NONE" : "\(username)",
            "VIP" : "[VIP] \(username)",
            "VIP_PLUS" : "[VIP+] \(username)",
            "MVP" : "[MVP] \(username)",
            "MVP_PLUS" : "[MVP+] \(username)",
            "SUPERSTAR" : "[MVP++] \(username)",
            "HELPER" : "[HELPER] \(username)",
            "MODERATOR" : "[MOD] \(username)",
            "GAME_MASTER": "[GM] \(username)",
            "ADMIN" : "[ADMIN] \(username)",
            "YOUTUBER" : "[YOUTUBE] \(username)"
        ]
        
        let plusColor = data["rankPlusColor"].stringValue
        
        let monthlyRankColor = data["monthlyRankColor"].stringValue
        
        let userRank = getRank(data: data)
        
        let rankString = ranks[userRank]
        let attributedString = NSMutableAttributedString(string: rankString!)
        
        //Set colors based on rank
        switch userRank {
        case "NONE":
            attributedString.setColor(color: colors["GRAY"]!)
            
        case "VIP":
            attributedString.setColor(color: colors["GREEN"]!)
            
        case "VIP_PLUS":
            attributedString.setColor(color: colors["GREEN"]!)
            attributedString.setColor(color: colors["GOLD"]!, stringValue: "+")
            
        case "MVP":
            attributedString.setColor(color: colors["AQUA"]!)
            
        case "MVP_PLUS":
            attributedString.setColor(color: colors["AQUA"]!)
            attributedString.setColor(color: colors[plusColor] ?? colors["RED"]!, stringValue: "+")
            
        case "SUPERSTAR":
            attributedString.setColor(color: colors[monthlyRankColor] ?? colors["GOLD"]!)
            attributedString.setColor(color: colors[plusColor] ?? colors["RED"]!, stringValue: "++")
            
        case "HELPER":
            attributedString.setColor(color: colors["BLUE"]!)
            
        case "MODERATOR":
            attributedString.setColor(color: colors["DARK_GREEN"]!)
            
        case "GAME_MASTER":
            attributedString.setColor(color: colors["DARK_GREEN"]!)
            
        case "ADMIN":
            attributedString.setColor(color: colors["RED"]!)
        
        case "YOUTUBER":
            attributedString.setColor(color: colors["RED"]!)
            attributedString.setColor(color: colors["WHITE"]!, stringValue: "YOUTUBE")
            
        default:
            attributedString.setColor(color: colors["GRAY"]!)
        }
        
        return attributedString
        
    }
    
    static func getAttributedStringForPurchasedRank(data: JSON, rankID: String) -> NSMutableAttributedString {
        let ranks = [
            "VIP" : "[VIP]",
            "VIP_PLUS" : "[VIP+]",
            "MVP" : "[MVP]",
            "MVP_PLUS" : "[MVP+]",
        ]
        
        let plusColor = data["rankPlusColor"].stringValue
        
        let rankString = ranks[rankID]
        let attributedString = NSMutableAttributedString(string: rankString!)
        
        switch rankID {
        case "VIP":
            attributedString.setColor(color: colors["GREEN"]!)
            
        case "VIP_PLUS":
            attributedString.setColor(color: colors["GREEN"]!)
            attributedString.setColor(color: colors["GOLD"]!, stringValue: "+")
            
        case "MVP":
            attributedString.setColor(color: colors["AQUA"]!)
            
        case "MVP_PLUS":
            attributedString.setColor(color: colors["AQUA"]!)
            attributedString.setColor(color: colors[plusColor] ?? colors["RED"]!, stringValue: "+")
        default:
            attributedString.setColor(color: colors["GRAY"]!)
        
        }
        
        return attributedString
        
    }
    
    
}
