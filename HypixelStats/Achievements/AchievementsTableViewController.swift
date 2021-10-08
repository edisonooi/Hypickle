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

    @IBOutlet var achievementsTable: NonScrollingTable!
    
    let headers = [
        1: "",
        2: "Recently Completed",
        3: "Easiest Remaining"
    ]
    
    let footers = [
        2,
        3
    ]
    
    let achievementCategories = [
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
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        
        if #available(iOS 15.0, *) {
            achievementsTable.sectionHeaderTopPadding = 0
        }
        
        let allAchievements = AchievementsManager.getCompletedAchievements(data: MinecraftUser.shared.playerHypixelData)
        allCompletedAchievements = allAchievements.allCompletedAchievements
        recentlyCompletedAchievements = allAchievements.recentlyCompletedAchievements
        incompleteOneTimes = allAchievements.incompleteOneTimes
        print(incompleteOneTimes)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + achievementCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            let slashString = NSMutableAttributedString(string: " / ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            var category = ""
            let value = NSMutableAttributedString()
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    category = "Points"
                    
                    let points = completionsAndPoints.points
                    let totalPoints = GlobalAchievementList.shared.totalAchievementPoints
                    let percentage = " (\(Utils.calculatePercentage(numerator: points, denominator: totalPoints)))"
                                
                    let pointsString = NSMutableAttributedString(string: points.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_yellow")!])
                    let totalString = NSMutableAttributedString(string: totalPoints.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_yellow")!])
                    
                    var percentageColor = UIColor.lightGray
                    
                    if points == totalPoints {
                        percentageColor = UIColor.systemGreen
                    }
                    
                    let percentageString = NSMutableAttributedString(string: String(percentage), attributes: [NSAttributedString.Key.foregroundColor: percentageColor])
                    
                    value.append(pointsString)
                    value.append(slashString)
                    value.append(totalString)
                    value.append(percentageString)
                    
                    
                } else if indexPath.row == 1 {
                    category = "Completions"
                    
                    let completions = completionsAndPoints.completions
                    let totalCompletions = GlobalAchievementList.shared.totalAchievementCount
                    let percentage = " (\(Utils.calculatePercentage(numerator: completions, denominator: totalCompletions)))"
                                
                    let completionsString = NSMutableAttributedString(string: completions.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_aqua")!])
                    let totalString = NSMutableAttributedString(string: totalCompletions.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_aqua")!])
                    
                    var percentageColor = UIColor.lightGray
                    
                    if totalCompletions == completions {
                        percentageColor = UIColor.systemGreen
                    }
                    
                    let percentageString = NSMutableAttributedString(string: String(percentage), attributes: [NSAttributedString.Key.foregroundColor: percentageColor])
                    
                    value.append(completionsString)
                    value.append(slashString)
                    value.append(totalString)
                    value.append(percentageString)
                }
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    category = "Legacy Points"
                    
                    let points = completionsAndPoints.legacyPoints
                    let totalPoints = GlobalAchievementList.shared.totalLegacyPoints
                    let percentage = " (\(Utils.calculatePercentage(numerator: points, denominator: totalPoints)))"
                                
                    let pointsString = NSMutableAttributedString(string: points.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_yellow")!])
                    let totalString = NSMutableAttributedString(string: totalPoints.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_yellow")!])
                    
                    var percentageColor = UIColor.lightGray
                    
                    if points == totalPoints {
                        percentageColor = UIColor.systemGreen
                    }
                    
                    let percentageString = NSMutableAttributedString(string: String(percentage), attributes: [NSAttributedString.Key.foregroundColor: percentageColor])
                    
                    value.append(pointsString)
                    value.append(slashString)
                    value.append(totalString)
                    value.append(percentageString)
                    
                    
                } else if indexPath.row == 1 {
                    category = "Legacy Completions"
                    
                    let completions = completionsAndPoints.legacyCompletions
                    let totalCompletions = GlobalAchievementList.shared.totalLegacyCount
                    let percentage = " (\(Utils.calculatePercentage(numerator: completions, denominator: totalCompletions)))"
                                
                    let completionsString = NSMutableAttributedString(string: completions.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_aqua")!])
                    let totalString = NSMutableAttributedString(string: totalCompletions.withCommas, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "mc_aqua")!])
                    
                    var percentageColor = UIColor.lightGray
                    
                    if totalCompletions == completions {
                        percentageColor = UIColor.systemGreen
                    }
                    
                    let percentageString = NSMutableAttributedString(string: String(percentage), attributes: [NSAttributedString.Key.foregroundColor: percentageColor])
                    
                    value.append(completionsString)
                    value.append(slashString)
                    value.append(totalString)
                    value.append(percentageString)
                }
            }
            
            
            
            cell.statCategory.text = category
            cell.statValue.attributedText = value
            
        }
        
        //Recently completed achievements
        if indexPath.section == 2 {
            var category = ""
            var value: Any = ""
            
            category = GameTypes.achievementGameIDToCleanName[recentlyCompletedAchievements[indexPath.row].gameID] ?? "-"
            value = recentlyCompletedAchievements[indexPath.row].name
            
            cell.configure(category: category, value: "\(value)")
        }
        
        if indexPath.section == 3 {
            let easiestRemainingCell = tableView.dequeueReusableCell(withIdentifier: AchievementPercentageTableViewCell.identifier, for: indexPath) as! AchievementPercentageTableViewCell
            
            if let achievement = incompleteOneTimes[safe: indexPath.row] {
                easiestRemainingCell.configure(game: GameTypes.achievementGameIDToCleanName[achievement.gameID] ?? "-", achievementName: achievement.name, percentage: String(format: "%.2f%%", achievement.globalPercentUnlocked))
                
            } else {
                easiestRemainingCell.configure(game: "-", achievementName: "-", percentage: "-")
            }
            
            return easiestRemainingCell
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        return cell
        
        
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 3 {
//            return 64
//        }
//        
//        return
//    }
    
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
    
    func getIncompleteOneTimes() -> [OneTimeAchievement] {
        var ret: [OneTimeAchievement] = []
        
        for (gameID, achievementGroup) in GlobalAchievementList.shared.globalList {
            let completedGroup = allCompletedAchievements[gameID]
            
            
        }
        
        return ret
    }
    
}
