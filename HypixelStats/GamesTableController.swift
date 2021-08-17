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
    var selectedGame = ""

    let gameList = [
        ["Arcade", "Arena", "Bedwars", "BuildBattle", "HungerGames", "MCGO", "Duels", "Walls3", "MurderMystery", "Paintball", "Pit", "Quake", "SkyWars", "SuperSmash", "SpeedUHC", "TNTGames", "GingerBread", "UHC", "VampireZ", "Walls", "Battleground"],
        ["TrueCombat", "SkyClash"]
    ]
    
    @IBOutlet var gamesTable: GamesTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTable.register(GamesTableViewCell.nib(), forCellReuseIdentifier: GamesTableViewCell.identifier)
        gamesTable.dataSource = self
        gamesTable.backgroundColor = .black
        gamesTable.rowHeight = 64

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTable.dequeueReusableCell(withIdentifier: GamesTableViewCell.identifier, for: indexPath) as! GamesTableViewCell
        
        let gameID = gameList[indexPath.section][indexPath.row]
        let iconID = gameID.lowercased() + "_icon"
        let gameTitle = Utils.databaseNameToCleanName[gameID]!
        
        cell.configure(imageName: iconID, title: gameTitle)
        
        
//        let verticalPadding: CGFloat = 8
//
//        let maskLayer = CALayer()
//        maskLayer.cornerRadius = 10
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: tableView.frame.size.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
//        cell.layer.mask = maskLayer
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedGame = gameList[indexPath.section][indexPath.row]
        
        performSegue(withIdentifier: "showGameStats", sender: self)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gameList.count
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return nil
//        }
//
//        let label = UILabel()
//        label.text = "Removed Games"
//        label.backgroundColor = .systemPink
//        return label
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? CGFloat.leastNormalMagnitude : 32
//    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "Removed Games"
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destVC = segue.destination as! GenericStatsViewController
        
        destVC.data = data[selectedGame] ?? ["": ""]
        destVC.gameID = selectedGame
        
        if selectedGame == "Arcade" {
            destVC.achievementsData = data["achievements"]
        }
        
    }
    

}
