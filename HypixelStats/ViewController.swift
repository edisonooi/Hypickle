//
//  ViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()

    }


    @IBAction func testButtonPressed(_ sender: Any) {
        print("Test button pressed")
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        let username = usernameTextField.text!
        
        if username == "" {
            return
        }
        
        //Show loading screen
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        
        //Reset status of MinecraftUser singleton so that dirty data is not displayed
        MinecraftUser.shared.isOnline = false
        MinecraftUser.shared.gameType = "-"
        
        let mojangAPIURL = "https://api.mojang.com/users/profiles/minecraft/\(username)"

        //Get actual username and uuid from search
        APIManager.getJSON(url: mojangAPIURL) {jsonData in
            
            if let name = jsonData["name"].string, let id = jsonData["id"].string {
                MinecraftUser.shared.username = name
                MinecraftUser.shared.uuid = id
                MinecraftUser.shared.skin = "https://crafatar.com/renders/body/\(id)?default=MHF_Steve&overlay=true"
                
                let hypixelAPIUrl = "https://api.hypixel.net/player?uuid=\(id)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                let hypixelAPIStatusUrl = "https://api.hypixel.net/status?uuid=\(id)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
                var gotHypixelData = true
                
                let group = DispatchGroup()
                group.enter()
                group.enter()
                
                //Get player's general stats
                APIManager.getJSON(url: hypixelAPIUrl) {playerData in
                    if playerData["player"].exists() {
                        MinecraftUser.shared.playerHypixelData = playerData["player"]
                    } else {
                        //TODO: UI Component that indicates hypixel API failure
                        print("Unable to retrieve data from Hypixel API")
                        gotHypixelData = false
                    }
                    group.leave()
                }
                
                //Get player's online status (separate endpoint)
                APIManager.getJSON(url: hypixelAPIStatusUrl) {statusData in
                    if statusData["success"].boolValue {
                        if statusData["session"]["online"].boolValue {
                            MinecraftUser.shared.isOnline = true
                            MinecraftUser.shared.gameType = GameTypes.allGames[statusData["session"]["gameType"].stringValue]?.cleanName ?? "-"
                            
                        }
                    } else {
                        print("Error getting online status")
                    }
                    group.leave()
                    
                }
                
                group.notify(queue: .main, execute: {
                    //Remove loading view upon completion of Hypixel API calls
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    
                    if gotHypixelData {
                        self.performSegue(withIdentifier: "showUserInfo", sender: self)
                    }
                })
                
            } else {
                //TODO: UI component that indicates invalid username
                print("Error, invalid username")
                
                //Remove loading view if invalid user
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                return
            }
        }
        
    }
    
    //Limit text field to 16 characters: longest possible minecraft username
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 16
    }
    
}

