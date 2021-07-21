//
//  GamesTableController.swift
//  HypixelStats
//
//  Created by codeplus on 7/19/21.
//

import UIKit
import SwiftyJSON

class GamesTableController: UITableViewController {

    var data: JSON = [:]

    let gameList = [
        ["Arcade", "Arena", "Bedwars", "BuildBattle", "HungerGames", "MCGO", "Duels", "Walls3", "MurderMystery", "Paintball", "Pit", "Quake", "SkyWars", "SuperSmash", "SpeedUHC", "TNTGames", "GingerBread", "UHC", "VampireZ", "Walls", "Battleground"],
        ["TrueCombat", "SkyClash"]
    ]
    
    @IBOutlet var gamesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTable.dataSource = self

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = GameTypes.databaseNameToCleanName[gameList[indexPath.section][indexPath.row]]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if gameList[indexPath.section][indexPath.row] == "Paintball" {
            performSegue(withIdentifier: "showPaintballStats", sender: self)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gameList.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let label = UILabel()
        label.text = "Removed Games"
        label.backgroundColor = .systemPink
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 32
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! GenericStatsViewController
        if segue.identifier == "showPaintballStats" {
            destVC.data = data["Paintball"] ?? ["": ""]
        }
    }
    

}
