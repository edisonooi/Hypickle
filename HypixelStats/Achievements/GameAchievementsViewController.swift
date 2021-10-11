//
//  GameAchievementsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/10/21.
//

import UIKit
import AMScrollingNavbar

class GameAchievementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var achievementGameID: String = ""
    var achievements: AchievementGroup?
    var completedAchievements: CompletedAchievementGroup?
    
    var oneTimeAchievementsSorted: [(String, OneTimeAchievement)] = []
    var tieredAchievementsSorted: [(String, TieredAchievement)] = []

    @IBOutlet weak var achievementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shortName = GameTypes.achievementGameIDToShortName[achievementGameID] {
            title = shortName + " Achievements"
        } else {
            title = "Couldn't Find Achievements"
        }
        
        if let safeAchievements = self.achievements {
            oneTimeAchievementsSorted = safeAchievements.oneTimeAchievements.sorted {
                $0.1.name < $1.1.name
            }
            
            tieredAchievementsSorted = safeAchievements.tieredAchievements.sorted {
                $0.1.name < $1.1.name
            }
        }
        
        achievementsTable.register(OneTimeAchievementTableViewCell.nib(), forCellReuseIdentifier: OneTimeAchievementTableViewCell.identifier)
        achievementsTable.register(TieredAchievementTableViewCell.nib(), forCellReuseIdentifier: TieredAchievementTableViewCell.identifier)
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        achievementsTable.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.followScrollView(achievementsTable, delay: 20.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.stopFollowingScrollView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tieredAchievementsSorted.count
        } else if section == 1 {
            return oneTimeAchievementsSorted.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 1 {
            let oneTimeAchievementCell = tableView.dequeueReusableCell(withIdentifier: OneTimeAchievementTableViewCell.identifier, for: indexPath) as! OneTimeAchievementTableViewCell
            
            let currentAchievement = oneTimeAchievementsSorted[indexPath.row].1
            let name = currentAchievement.name
            let shortName = GameTypes.achievementGameIDToShortName[currentAchievement.gameID] ?? "-"
            let description = currentAchievement.description
            let points = currentAchievement.points
            let gamePercentUnlocked = currentAchievement.gamePercentUnlocked
            let globalPercentUnlocked = currentAchievement.globalPercentUnlocked
            
            var isComplete: Bool = false
            
            if let completed = completedAchievements {
                isComplete = completed.oneTimesCompleted.contains(oneTimeAchievementsSorted[indexPath.row].0)
            }
            
            oneTimeAchievementCell.configure(name: name, description: description, shortName: shortName, points: points, gamePercentage: gamePercentUnlocked, globalPercentage: globalPercentUnlocked, isComplete: isComplete)
            
            return oneTimeAchievementCell
        }
        
        else if indexPath.section == 0 {
            
            let tieredAchievementCell = tableView.dequeueReusableCell(withIdentifier: TieredAchievementTableViewCell.identifier, for: indexPath) as! TieredAchievementTableViewCell
            
            let currentAchievement = tieredAchievementsSorted[indexPath.row].1
            let name = currentAchievement.name
            let description = currentAchievement.description
            let tiers = currentAchievement.tiers
            var numCompletedTiers = 0
            var completedAmount = 0
            
            if let completedTiers = completedAchievements?.tieredCompletions {
                let tierInfo: (Int, Int) = completedTiers[tieredAchievementsSorted[indexPath.row].0] ?? (0, 0)
                
                numCompletedTiers = tierInfo.0
                completedAmount = tierInfo.1
                
            }
            
            tieredAchievementCell.configure(name: name, description: description, tiers: tiers, numCompletedTiers: numCompletedTiers, completedAmount: completedAmount)
            
            return tieredAchievementCell
            
            
        }
        
        return cell
    }
    
    


}
