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

    @IBOutlet weak var achievementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cleanName = GameTypes.achievementGameIDToCleanName[achievementGameID] {
            title = cleanName + " Achievements"
        } else {
            title = "Couldn't Find Achievements"
        }
        
        
        
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
        if let safeAchievements = self.achievements {
            if section == 0 {
                return safeAchievements.oneTimeAchievements.count
            }
            
            if section == 1 {
                return safeAchievements.tieredAchievements.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }


}
