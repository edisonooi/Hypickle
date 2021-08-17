//
//  StatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/16/21.
//

import UIKit
import SwiftyJSON

class StatsViewController: UIViewController {
    
    var user: MinecraftUser?
    var allStatsData: JSON = ["": ""]
    
    @IBOutlet weak var gameTableContainerView: UIView!
    
    var gameStats: JSON = [:]
    
    
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var skinImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let username = user?.username {
            usernameTextField.text = username
            title = username + "'s Stats"
        } else {
            title = "No User Found"
        }
        
        if let skinURL = user?.skin, skinURL != "" {
            downloadSkinImage(from: URL(string: skinURL)!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showGamesTable" {
            let gamesTableVC = segue.destination as! GamesTableController
            
            gamesTableVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            let url = "https://api.hypixel.net/player?uuid=\(user!.uuid)&key=4609ba54-b794-4a48-aee5-39bc00edea83"
            
            APIManager.getJSON(specific_url: url) {jsonData in

                if jsonData["player"].dictionary != nil {
                    self.allStatsData = jsonData["player"]

                    self.gameStats = jsonData["player"]["stats"]
                    
                    gamesTableVC.data = self.gameStats

                } else {
                    print("Error retrieving all stats")
                    return
                }
            }
        }
    }
    
    func downloadSkinImage(from url: URL) {
        
        APIManager.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.skinImageView.image = UIImage(data: data)
            }
        }
    }

}
