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
    
    var user: MinecraftUser?
    
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
        let username = usernameTextField.text!
        var name = ""
        var uuid = ""
        
        let url = "https://api.mojang.com/users/profiles/minecraft/\(username)"

        APIManager.getJSON(url: url) {jsonData in
            
            if let safeName = jsonData["name"].string, let safeID = jsonData["id"].string {
                name = safeName
                uuid = safeID
                
                self.user = MinecraftUser(username: name, uuid: uuid)
                
                let hypixelAPIUrl = "https://api.hypixel.net/player?uuid=\(self.user!.uuid)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                
                APIManager.getJSON(url: hypixelAPIUrl) {playerData in
                    if playerData["player"].exists() {
                        self.user?.playerHypixelData = playerData["player"]
                        
                        let hypixelAPIStatusUrl = "https://api.hypixel.net/status?uuid=\(uuid)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                        
                        APIManager.getJSON(url: hypixelAPIStatusUrl) {statusData in
                            if statusData["success"].boolValue {
                                if statusData["session"]["online"].boolValue {
                                    self.user?.isOnline = true
                                    self.user?.gameType = GameTypes.allGames[statusData["session"]["gameType"].stringValue]?.cleanName ?? "-"
                                    
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
            destVC.user = self.user
        }
    }
    
    
}

