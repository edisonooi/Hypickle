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
    
    @IBOutlet var gamesTable: GamesTable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTable.dataSource = self
        gamesTable.backgroundColor = .black

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        cell.textLabel?.text = GameTypes.databaseNameToCleanName[gameList[indexPath.section][indexPath.row]]
        
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: tableView.frame.size.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //All segues from this table have identifier "show{game}Stats"
        let identifer = "show" + gameList[indexPath.section][indexPath.row] + "Stats"
        
        performSegue(withIdentifier: identifer, sender: self)
        
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

        let destVC = segue.destination as! GenericStatsViewController
        
        //Getting game type from segue identifier show{game}Stats
        let str = segue.identifier!
        let start = str.index(str.startIndex, offsetBy: 4)
        let end = str.index(str.endIndex, offsetBy: -5)
        let range = start..<end
         
        let game = String(str[range])
        
        destVC.data = data[game] ?? ["": ""]
        
        if game == "Arcade" {
            destVC.achievementsData = data["achievements"]
        }
        
    }
    

}
