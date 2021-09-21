//
//  ViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import UIKit
import SwiftyJSON
import Keys

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var errorTextView: UITextView!
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ROOT VIEW LOADED")
        
        usernameTextField.layer.cornerRadius = 5
        usernameTextField.layer.borderWidth = 0.5
        usernameTextField.layer.borderColor = UIColor.systemGray.cgColor
        usernameTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        searchButton.layer.cornerRadius = 8
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.systemGray.cgColor
        
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(aboutButtonPressed))
        
        initializeAchievementList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorTextView.text = ""
    }
    
    
    @IBAction func keyboardReturnPressed(_ sender: Any) {
        performSearch()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSearch()
    }
    
    @objc func aboutButtonPressed() {
        performSegue(withIdentifier: "showAboutPage", sender: self)
    }
    
    func performSearch() {
        errorTextView.text = ""
        
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
        MinecraftUser.shared.playerHypixelData = [:]
        
        let mojangAPIURL = "https://api.mojang.com/users/profiles/minecraft/\(username)"

        //Get actual username and uuid from search
        APIManager.getJSON(url: mojangAPIURL) {jsonData in
            
            if let name = jsonData["name"].string, let id = jsonData["id"].string {
                MinecraftUser.shared.username = name
                MinecraftUser.shared.uuid = id
                
                let keys = HypixelStatsKeys()
                
                let hypixelAPIUrl = "https://api.hypixel.net/player?uuid=\(id)&key=\(keys.hypixelAPIKey)"
                let hypixelAPIStatusUrl = "https://api.hypixel.net/status?uuid=\(id)&key=\(keys.hypixelAPIKey)"
                var gotHypixelData = true
                
                
                self.group.enter()
                self.group.enter()
                
                //Get player's general stats
                APIManager.getJSON(url: hypixelAPIUrl) {playerData in
                    if playerData["player"].exists() {
                        if playerData["player"] == JSON.null {
                            self.errorTextView.text = name + " has never played on Hypixel!"
                            gotHypixelData = false
                        } else {
                            MinecraftUser.shared.playerHypixelData = playerData["player"]
                        }
                        
                    } else {
                        if let errorMessage = playerData["failure"].string {
                            self.errorTextView.text = errorMessage
                        } else {
                            self.errorTextView.text = "Error: Could not retrieve data from Hypixel API"
                        }
                        
                        gotHypixelData = false
                    }
                    self.group.leave()
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
                    self.group.leave()
                    
                }
                
                self.group.notify(queue: .main, execute: {
                    //Remove loading view upon completion of Hypixel API calls
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                    
                    if gotHypixelData {
                        self.performSegue(withIdentifier: "showUserInfo", sender: self)
                    }
                })
                
            } else {
                self.errorTextView.text = "Error: Invalid username"
                
                //Remove loading view if invalid user
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                return
            }
        }
    }
    
    //Limit text field to 16 characters: longest possible minecraft username
    //This code causes a bug which prevents user from deleting emojis from the text field
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let currentCharacterCount = textField.text?.count ?? 0
//        if range.length + range.location > currentCharacterCount {
//            return false
//        }
//        let newLength = currentCharacterCount + string.count - range.length
//        return newLength <= 16
//    }
    
    func initializeAchievementList() {
        self.group.enter()
        
        APIManager.getJSON(url: "https://api.hypixel.net/resources/achievements") {json in
            if(json["success"].boolValue) {
                GlobalAchievementList.initializeGlobalList(data: json["achievements"])
            }
            
            self.group.leave()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        usernameTextField.layer.borderColor = UIColor.systemGray.cgColor
        searchButton.layer.borderColor = UIColor.systemGray.cgColor
    }
    
}

