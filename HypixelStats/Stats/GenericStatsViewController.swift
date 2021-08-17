//
//  GenericStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit
import SwiftyJSON

class GenericStatsViewController: UIViewController {
        
    var data: JSON = [:]
    var achievementsData: JSON = [:]
    var gameID: String = ""
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var statsTable: UITableView!
    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var coinsView: UIView!
    @IBOutlet weak var coinAmount: UILabel!
    
    
    lazy var dataManager: StatsManager = {
        
        switch gameID {
        case "Arcade":
            return ArcadeStatsManager(data: data, achievementsData: achievementsData)
        case "Arena":
            return ArenaStatsManager(data: data)
        case "Bedwars":
            return BedwarsStatsManager(data: data)
        case "HungerGames":
            return HungerGamesStatsManager(data: data)
        case "BuildBattle":
            return BuildBattleStatsManager(data: data)
        case "MCGO":
            return MCGOStatsManager(data: data)
        case "Duels":
            return DuelsStatsManager(data: data)
        case "Walls3":
            return Walls3StatsManager(data: data)
        case "MurderMystery":
            return MurderMysteryStatsManager(data: data)
        case "Paintball":
            return PaintballStatsManager(data: data)
        case "Pit":
            return PitStatsManager(data: data)
        case "Quake":
            return QuakeStatsManager(data: data)
        case "SkyWars":
            return SkyWarsStatsManager(data: data)
        case "SuperSmash":
            return SuperSmashStatsManager(data: data)
        case "SpeedUHC":
            return SpeedUHCStatsManager(data: data)
        case "TNTGames":
            return TNTGamesStatsManager(data: data)
        case "GingerBread":
            return GingerBreadStatsManager(data: data)
        case "UHC":
            return UHCStatsManager(data: data)
        case "VampireZ":
            return VampireZStatsManager(data: data)
        case "Walls":
            return WallsStatsManager(data: data)
        case "Battleground":
            return BattlegroundStatsManager(data: data)
        case "TrueCombat":
            return TrueCombatStatsManager(data: data)
        case "SkyClash":
            return SkyClashStatsManager(data: data)
        default:
            print("Invalid game ID")
        }
        return BedwarsStatsManager(data: data)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsTable.allowsSelection = true
    
        //gameTitle.textAlignment = .center
        //gameTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        gameTitle.text = Utils.databaseNameToCleanName[gameID]
        
        gameIcon.image = UIImage(named: gameID.lowercased() + "_icon")
        gameIcon.translatesAutoresizingMaskIntoConstraints = false
        
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.dataSource = dataManager
        statsTable.delegate = dataManager
        
        coinsView.backgroundColor = .systemGray5
        coinsView.layer.cornerRadius = 16
        coinsView.layer.masksToBounds = true
        
        coinAmount.text = data["coins"].intValue.withCommas
        
        
        
        
        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
