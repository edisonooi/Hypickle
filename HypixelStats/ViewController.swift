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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
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
                        
                        self.performSegue(withIdentifier: "showUserInfo", sender: self)
                    } else {
                        print("Unable to retrieve data from Hypixel API")
                        return
                    }
                    
                }
                
            } else {
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

