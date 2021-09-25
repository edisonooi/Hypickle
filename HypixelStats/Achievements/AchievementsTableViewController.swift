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

    @IBOutlet var achievementsTable: NonScrollingTable!
    
    let headers = [
        1: "",
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
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        //achievementsTable.estimatedRowHeight = 0
        
        allCompletedAchievements = AchievementsManager.getCompletedAchievements(data: MinecraftUser.shared.playerHypixelData)

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
        if indexPath.section == 0 || indexPath.section == 1 {
            
            let completionsAndPoints = getTotalCompletionsAndPoints()
            let slashString = NSMutableAttributedString(string: " / ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            var category = ""
            var value = NSMutableAttributedString()
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    category = "Points"
                    
                    var points = completionsAndPoints.points
                    var totalPoints = GlobalAchievementList.shared.totalAchievementPoints
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
                    
                    var completions = completionsAndPoints.completions
                    var totalCompletions = GlobalAchievementList.shared.totalAchievementCount
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
                    
                    var points = completionsAndPoints.points
                    var totalPoints = GlobalAchievementList.shared.totalAchievementPoints
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
                    
                    var completions = completionsAndPoints.completions
                    var totalCompletions = GlobalAchievementList.shared.totalAchievementCount
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
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                return 32
            } else {
                return 64
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = headers[section] {
            if headerTitle == "" {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 32))
                headerView.backgroundColor = .red
                
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
        return 0
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
