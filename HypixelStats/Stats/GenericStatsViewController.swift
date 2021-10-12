//
//  GenericStatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit
import SwiftyJSON
import AMScrollingNavbar

class GenericStatsViewController: UIViewController {
        
    var data: JSON = [:]
    var achievementsData: JSON = [:]
    var gameID: String = ""
    var coinsView: CoinsView?
    
    @IBOutlet weak var statsTable: UITableView!
    
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
            return MurderMysteryStatsManager(data: data, achievementsData: achievementsData)
        case "Paintball":
            return PaintballStatsManager(data: data)
        case "Pit":
            return PitStatsManager(data: data)
        case "Quake":
            return QuakeStatsManager(data: data, achievementsData: achievementsData)
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
        
        title = GameTypes.databaseNameToCleanName[gameID]
        
        statsTable.allowsSelection = true
        statsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        statsTable.dataSource = dataManager
        statsTable.delegate = dataManager
        statsTable.estimatedRowHeight = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.followScrollView(statsTable, delay: 20.0)
        }
        
        updateCoins()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.stopFollowingScrollView()
        }
    }
    
    func updateCoins() {
        
        if coinsView == nil {
            coinsView = CoinsView.instanceFromNib()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: coinsView!)
        }
        
        if gameID == "Pit" {
            coinsView?.coinsIcon.image = UIImage(named: "gold_ingot")
            coinsView?.coinAmount.text = Int(floor(data["profile"]["cash"].doubleValue)).withCommas
        } else {
            coinsView?.coinsIcon.image = UIImage(named: "coin_icon")
            coinsView?.coinAmount.text = data["coins"].intValue.withCommas
        }
        
        coinsView!.backgroundColor = UIColor(named: "coins_view_background")!
        coinsView!.layer.cornerRadius = 14
        coinsView!.layer.masksToBounds = true
    }

}
