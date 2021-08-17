//
//  MojangAPIManager.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import Foundation

class MojangAPIManager {
    
    //Returns full skin image from Mojang API
    static func getSkinImage(uuid: String) -> String{
        //TODO: Get steve skin
        var skin = ""
        
        let skinURL = "https://sessionserver.mojang.com/session/minecraft/profile/\(uuid)"
        APIManager.getJSON(specific_url: skinURL) {jsonData in
            if let skinData = jsonData["properties"] as? Array<Dictionary<String,Any>> {
                var valueString = skinData[0]["value"] as! String
                
                let data = Data(base64Encoded: valueString)
                valueString = String(data: data!, encoding: .utf8)!
                
                let targetString = "\"SKIN\" : {"
                
                if valueString.contains(targetString) {
                    print("Found target string")
                    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(in: valueString, options: [], range: NSRange(location: 0, length: valueString.utf16.count))
                    
                    if let range = Range(matches[0].range, in: valueString) {
                        let skinURL = valueString[range]
                        print(skinURL)
                        skin = String(skinURL)
                    } else {
                        print("Could not find skin url, might be Steve/Alex.")
                    }
                }
            }
        }
        
        print(skin)
        
        return skin
    }
    
    //Convert a JSON style string to dictionary
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
