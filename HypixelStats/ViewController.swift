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
        
        // Do any additional setup after loading the view.
    }


    @IBAction func testButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let username = usernameTextField.text!
        var name = ""
        var uuid = ""
        
        let url = "https://api.mojang.com/users/profiles/minecraft/\(username)"

        APIManager.getJSON(specific_url: url) {jsonData in
            
            if let safeName = jsonData["name"].string, let safeID = jsonData["id"].string {
                name = safeName
                uuid = safeID
                
                self.user = MinecraftUser(username: name, uuid: uuid)
                
                self.performSegue(withIdentifier: "openUserStats", sender: self)
                
            } else {
                print("Error, invalid username")
                return
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statsVC = segue.destination as? StatsViewController {
            statsVC.user = user
        }
    }
    
    
}

