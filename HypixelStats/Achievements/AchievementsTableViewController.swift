//
//  AchievementsTableViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import UIKit
import SwiftyJSON

class AchievementsTableViewController: UITableViewController {
    
    //var data: JSON = [:]
    var allCompletedAchievements: [String: CompletedAchievementGroup] = [:]
    var recentlyCompletedAchievements: [OneTimeAchievement] = []
    var incompleteOneTimes: [OneTimeAchievement] = []
    
    var selectedGame = ""

    @IBOutlet var achievementsTable: NonScrollingTable!
    
    let headers = [
        1: "",
        2: "Recently Completed",
        3: "Easiest Remaining",
        4: "General",
        5: "",
        6: "Seasonal",
        7: "Removed Games"
    ]
    
    let footers = [
        2,
        3
    ]
    
    let achievementGameIDs = [
        [
            "general",
            "housing"
        ],
        [
            "arcade",
            "arena",
            "bedwars",
            "blitz",
            "buildbattle",
            "copsandcrims",
            "duels",
            "walls3",
            "murdermystery",
            "paintball",
            "pit",
            "quake",
            "skyblock",
            "skywars",
            "supersmash",
            "speeduhc",
            "tntgames",
            "gingerbread",
            "uhc",
            "vampirez",
            "walls",
            "warlords"
        ],
        [
            "christmas2017",
            "easter",
            "halloween2017",
            "summer"
        ],
        [
            "truecombat",
            "skyclash"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        achievementsTable.allowsSelection = true
        achievementsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        achievementsTable.register(AchievementPercentageTableViewCell.nib(), forCellReuseIdentifier: AchievementPercentageTableViewCell.identifier)
        achievementsTable.register(GameAchievementsInfoTableViewCell.nib(), forCellReuseIdentifier: GameAchievementsInfoTableViewCell.identifier)
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        
        if #available(iOS 15.0, *) {
            achievementsTable.sectionHeaderTopPadding = 0
        }
        
        let allAchievements = AchievementsManager.getCompletedAchievements(data: MinecraftUser.shared.playerHypixelData)
        allCompletedAchievements = allAchievements.allCompletedAchievements
        recentlyCompletedAchievements = allAchievements.recentlyCompletedAchievements
        incompleteOneTimes = allAchievements.incompleteOneTimes
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + achievementGameIDs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 3 {
            return achievementGameIDs[section - 4].count
        }
        
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 5
        case 3:
            return 5
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
        //Overall stats
        if indexPath.section == 0 || indexPath.section == 1 {
            
            let completionsAndPoints = getTotalCompletionsAndPoints()
            
            var category = ""
            let value = NSMutableAttributedString()
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    category = "Points"
                    
                    let points = completionsAndPoints.points
                    let totalPoints = GlobalAchievementList.shared.totalAchievementPoints
                    
                    let pointsStrings = AchievementsManager.getPointsStrings(earnedPoints: points, totalPoints: totalPoints)
                    
                    value.append(pointsStrings.ratioString)
                    value.append(NSAttributedString(string: " "))
                    value.append(pointsStrings.percentString)
                    
                    
                } else if indexPath.row == 1 {
                    category = "Completions"
                    
                    let completions = completionsAndPoints.completions
                    let totalCompletions = GlobalAchievementList.shared.totalAchievementCount
                    
                    let countsStrings = AchievementsManager.getCountsStrings(earnedCount: completions, totalCount: totalCompletions)
                    
                    value.append(countsStrings.ratioString)
                    value.append(NSAttributedString(string: " "))
                    value.append(countsStrings.percentString)
                }
                
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    category = "Legacy Points"
                    
                    let points = completionsAndPoints.legacyPoints
                    let totalPoints = GlobalAchievementList.shared.totalLegacyPoints
                    
                    let pointsStrings = AchievementsManager.getPointsStrings(earnedPoints: points, totalPoints: totalPoints)
                    
                    value.append(pointsStrings.ratioString)
                    value.append(NSAttributedString(string: " "))
                    value.append(pointsStrings.percentString)
                    
                    
                } else if indexPath.row == 1 {
                    category = "Legacy Completions"
                    
                    let completions = completionsAndPoints.legacyCompletions
                    let totalCompletions = GlobalAchievementList.shared.totalLegacyCount
                    
                    let countsStrings = AchievementsManager.getCountsStrings(earnedCount: completions, totalCount: totalCompletions)
                    
                    value.append(countsStrings.ratioString)
                    value.append(NSAttributedString(string: " "))
                    value.append(countsStrings.percentString)
                }
            }
            
            cell.statCategory.text = category
            cell.statValue.attributedText = value
            
        }
        
        //Recently completed achievements
        else if indexPath.section == 2 {
            var category = ""
            var value: Any = ""
            
            category = GameTypes.achievementGameIDToCleanName[recentlyCompletedAchievements[indexPath.row].gameID] ?? "-"
            value = recentlyCompletedAchievements[indexPath.row].name
            
            cell.configure(category: category, value: "\(value)")
        }
        
        else if indexPath.section == 3 {
            let easiestRemainingCell = tableView.dequeueReusableCell(withIdentifier: AchievementPercentageTableViewCell.identifier, for: indexPath) as! AchievementPercentageTableViewCell
            
            if let achievement = incompleteOneTimes[safe: indexPath.row] {
                easiestRemainingCell.configure(game: GameTypes.achievementGameIDToCleanName[achievement.gameID] ?? "-", achievementName: achievement.name, percentage: String(format: "%.2f%%", achievement.globalPercentUnlocked))
                
            } else {
                easiestRemainingCell.configure(game: "-", achievementName: "-", percentage: "-")
            }
            
            return easiestRemainingCell
        }
        
        else if indexPath.section > 3 {
            let gameCell = tableView.dequeueReusableCell(withIdentifier: GameAchievementsInfoTableViewCell.identifier, for: indexPath) as! GameAchievementsInfoTableViewCell
            
            let achievementGameID = achievementGameIDs[indexPath.section - 4][indexPath.row]
            let databaseName = GameTypes.achievementGameIDToDatabaseName[achievementGameID] ?? ""
            let imageName = databaseName.lowercased() + "_icon"
            let gameName = GameTypes.achievementGameIDToCleanName[achievementGameID] ?? ""
            
            var points = (allCompletedAchievements[achievementGameID]?.completedPoints ?? 0)
            var totalPoints = (GlobalAchievementList.shared.globalList[achievementGameID]?.totalPoints ?? 0) - (GlobalAchievementList.shared.globalList[achievementGameID]?.totalLegacyPoints ?? 0)
            
            if indexPath.section == 7 {
                points = allCompletedAchievements[achievementGameID]?.legacyCompletedPoints ?? 0
                totalPoints = (GlobalAchievementList.shared.globalList[achievementGameID]?.totalLegacyPoints ?? 0)
            }
            
            let pointsStrings = AchievementsManager.getPointsStrings(earnedPoints: points, totalPoints: totalPoints)
            
            gameCell.configure(icon: imageName, name: gameName, pointsRatio: pointsStrings.ratioString, percentage: pointsStrings.percentString)
            
            return gameCell
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section > 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedGame = achievementGameIDs[indexPath.section - 4][indexPath.row]
        
        performSegue(withIdentifier: "showGameAchievements", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                return 32
            } else {
                return 64
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 32))
                headerView.backgroundColor = .clear
                
                return headerView
            } else {
                let headerView = GenericHeaderView.instanceFromNib()
                headerView.title.text = headerTitle
                
                if headerTitle == "Easiest Remaining" {
                    headerView.rightLabel.font = UIFont.systemFont(ofSize: 12)
                    headerView.rightLabel.text = "% Completed (Global)"
                }
                
                if section > 3 {
                    headerView.rightLabel.font = UIFont.systemFont(ofSize: 14)
                    headerView.rightLabel.text = "Points"
                }
                
                return headerView
            }
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if footers.contains(section) {
            return 36
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if footers.contains(section) {

            let detailsButton = UIButton(type: .custom)
            
            detailsButton.setTitle("See More Details", for: .normal)
            
            if section == 2 {
                detailsButton.addTarget(self, action: #selector(recentlyCompletedButtonTapped), for: .touchUpInside)
            } else if section == 3 {
                detailsButton.addTarget(self, action: #selector(easiestRemainingButtonTapped), for: .touchUpInside)
            }
            
            detailsButton.setTitleColor(.link, for: .normal)
            detailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            detailsButton.titleLabel?.textAlignment = .center
            detailsButton.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 24)
            detailsButton.backgroundColor = .clear

            return detailsButton
        }

        return nil
    }
    
    @objc func recentlyCompletedButtonTapped() {
        print("Recent")
    }
    
    @objc func easiestRemainingButtonTapped() {
        print("Easiest")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameAchievements" {
            let destVC = segue.destination as! GameAchievementsViewController
            
            destVC.achievementGameID = selectedGame
            destVC.achievements = GlobalAchievementList.shared.globalList[selectedGame]
            destVC.completedAchievements = allCompletedAchievements[selectedGame]
        }
    }
    
    
    
    func getTotalCompletionsAndPoints() -> (completions: Int, points: Int, legacyCompletions: Int, legacyPoints: Int) {
        var completions = 0
        var points = 0
        var legacyCompletions = 0
        var legacyPoints = 0
        
        for (_, group) in allCompletedAchievements {
            completions += group.completedCount
            points += group.completedPoints
            legacyCompletions += group.legacyCompletedCount
            legacyPoints += group.legacyCompletedPoints
        }
        
        return (completions: completions, points: points, legacyCompletions: legacyCompletions, legacyPoints: legacyPoints)
    }
    
}
