//
//  ViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func testButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        MinecraftUser.shared.isOnline = false
        MinecraftUser.shared.gameType = "-"
        
        let username = usernameTextField.text!
        
        let url = "https://api.mojang.com/users/profiles/minecraft/\(username)"

        APIManager.getJSON(url: url) {jsonData in
            
            if let name = jsonData["name"].string, let id = jsonData["id"].string {
                MinecraftUser.shared.username = name
                MinecraftUser.shared.uuid = id
                MinecraftUser.shared.skin = "https://crafatar.com/renders/body/\(id)?default=MHF_Steve&overlay=true"
                
                let hypixelAPIUrl = "https://api.hypixel.net/player?uuid=\(id)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                
                APIManager.getJSON(url: hypixelAPIUrl) {playerData in
                    if playerData["player"].exists() {
                        MinecraftUser.shared.playerHypixelData = playerData["player"]
                        
                        let hypixelAPIStatusUrl = "https://api.hypixel.net/status?uuid=\(id)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                        
                        APIManager.getJSON(url: hypixelAPIStatusUrl) {statusData in
                            if statusData["success"].boolValue {
                                if statusData["session"]["online"].boolValue {
                                    MinecraftUser.shared.isOnline = true
                                    MinecraftUser.shared.gameType = GameTypes.allGames[statusData["session"]["gameType"].stringValue]?.cleanName ?? "-"
                                    
                                }
                            } else {
                                print("Error getting online status")
                            }
                            
                            self.performSegue(withIdentifier: "showUserInfo", sender: self)
                            
                        }
                        
                    } else {
                        //TODO: UI Component that indicates hypixel API failure
                        print("Unable to retrieve data from Hypixel API")
                        return
                    }
                    
                }
                
            } else {
                //TODO: UI component that indicates invalid username
                print("Error, invalid username")
                return
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PlayerInfoTabBarController {
            
        }
    }
    
    
}

