//
//  AchievementMoreDetailsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/13/21.
//

import UIKit

class AchievementMoreDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var achievementsList: [OneTimeAchievement] = []
    var achievementsAreCompleted: Bool = false

    @IBOutlet weak var achievementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        achievementsTable.delegate = self
        achievementsTable.dataSource = self
        achievementsTable.allowsSelection = false
        
        achievementsTable.register(OneTimeAchievementTableViewCell.nib(), forCellReuseIdentifier: OneTimeAchievementTableViewCell.identifier)
        
        title = achievementsAreCompleted ? "Recently Completed Achievements" : "Easiest Remaining Achievements"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? achievementsList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let oneTimeAchievementCell = tableView.dequeueReusableCell(withIdentifier: OneTimeAchievementTableViewCell.identifier, for: indexPath) as! OneTimeAchievementTableViewCell
            
            let currentAchievement = achievementsList[indexPath.row]
            
            let name = currentAchievement.name
            let shortName = GameTypes.achievementGameIDToShortName[currentAchievement.gameID] ?? "-"
            let description = currentAchievement.achievementDescription
            let points = currentAchievement.points
            let gamePercentUnlocked = currentAchievement.gamePercentUnlocked
            let globalPercentUnlocked = currentAchievement.globalPercentUnlocked
            
            let isComplete = achievementsAreCompleted
            
            oneTimeAchievementCell.configure(name: shortName + ": " + name, description: description, shortName: shortName, points: points, gamePercentage: gamePercentUnlocked, globalPercentage: globalPercentUnlocked, isComplete: isComplete)
            
            return oneTimeAchievementCell
        }
        
        let dummyCell = UITableViewCell()
        return dummyCell
    }

}
