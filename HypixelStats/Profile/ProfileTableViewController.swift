//
//  ProfileTableViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/30/21.
//

import UIKit
import Foundation
import SwiftyJSON

class ProfileTableViewController: UITableViewController {
    
    let data: JSON = MinecraftUser.shared.playerHypixelData
    
    var hasNameHistory: Bool = true
    var hasRankHistory: Bool = true
    

    @IBOutlet var profileTable: NonScrollingTable!
    
    lazy var profileTableData: [[CellData]] = {
        var ret: [[CellData]] = []
        
        var nameHistory = getNameHistory()
        var rankHistory = getRankHistory()
        
        if !nameHistory.isEmpty {
            ret.append([CellData(headerData: ("Name History", ""), sectionData: nameHistory)])
        } else {
            hasNameHistory = false
        }
        
        if !rankHistory.isEmpty {
            ret.append([CellData(headerData: ("Rank History", ""), attributedData: rankHistory)])
        } else {
            hasRankHistory = false
        }
        
        var didClaimReward = dailyRewardClaimed()
        var claimedString = didClaimReward ? "Claimed!" : "Not Claimed"
        var claimedColor = didClaimReward ? UIColor.systemGreen : UIColor.systemRed
        
        var onlineStatus = getOnlineStatus()
        
        var firstLogin = data["firstLogin"].exists() ? Utils.convertToDateStringFormat(milliseconds: data["firstLogin"].uInt64Value) : "Unknown"
        var lastLogin = data["lastLogin"].exists() ? Utils.convertToDateStringFormat(milliseconds: data["lastLogin"].uInt64Value) : "Unknown"
        var lastLogout = data["lastLogout"].exists() ? Utils.convertToDateStringFormat(milliseconds: data["lastLogout"].uInt64Value) : "Unknown"
        
        var generalStats =  [
            
            [
                CellData(headerData: ("Network Level", String(format: "%.2f", getNetworkLevel())), color: UIColor.MinecraftColors.cyan),
                CellData(headerData: ("Total EXP", data["networkExp"].uInt64Value), color: UIColor.MinecraftColors.cyan),
                CellData(headerData: ("EXP to Next Level", getXPToNextLevel(currentXP: data["networkExp"].uInt64Value)), color: UIColor.MinecraftColors.cyan)
            ],
            
            [
                CellData(headerData: ("Karma", data["karma"].intValue), color: UIColor.MinecraftColors.lightPurple),
                CellData(headerData: ("Achievement Points", data["achievementPoints"].intValue), color: UIColor.MinecraftColors.yellow),
                CellData(headerData: ("Quests Completed", getQuestsCompleted()), color: UIColor.MinecraftColors.green),
                CellData(headerData: ("Challenges Completed", getChallengesCompleted()), color: UIColor.MinecraftColors.green)
            ],
            
            [
                CellData(headerData: ("Coin Multiplier", getCoinMultiplier())),
                CellData(headerData: ("Total Coins", getTotalCoins()), color: UIColor.MinecraftColors.gold)
            ],
            
            [
                CellData(headerData: ("Total Wins", getTotalWins())),
                CellData(headerData: ("Total Kills", getTotalKills()))
            ],
            
            [
                CellData(headerData: ("Daily Reward", claimedString), color: claimedColor),
                CellData(headerData: ("Rewards Claimed", data["totalRewards"].intValue)),
                CellData(headerData: ("Current Streak", data["rewardScore"].intValue)),
                CellData(headerData: ("Highest Streak", data["rewardHighScore"].intValue))
            ],
            
            [
                CellData(headerData: ("Ranks Gifted", data["giftingMeta"]["ranksGiven"].intValue), color: UIColor.MinecraftColors.darkPurple),
                CellData(headerData: ("Gifts Given", data["giftingMeta"]["bundlesGiven"].intValue), color: UIColor.MinecraftColors.lightPurple),
                CellData(headerData: ("Gifts Received", data["giftingMeta"]["bundlesReceived"].intValue), color: UIColor.MinecraftColors.lightPurple)
            ],
            
            [
                CellData(headerData: ("Status", onlineStatus.0), color: onlineStatus.1),
                CellData(headerData: ("Game", MinecraftUser.shared.gameType))
            ],
            
            [
                CellData(headerData: ("First Login", firstLogin)),
                CellData(headerData: ("Last Login", lastLogin)),
                CellData(headerData: ("Last Logout", lastLogout))
            ]
        ]
        
        ret.append(contentsOf: generalStats)
        
        return ret
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        profileTable.dataSource = self
        profileTable.estimatedRowHeight = 0
        
//        if #available(iOS 15.0, *) {
//            profileTable.sectionHeaderTopPadding = 0
//        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return profileTableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if profileTableData[section][0].isOpened {
            return profileTableData[section][0].sectionData.count == 0 ? profileTableData[section][0].attributedData.count + 1 : profileTableData[section][0].sectionData.count + 1
        } else {
            return profileTableData[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        let section = indexPath.section
        let row = indexPath.row
        
        var category = ""
        var value: Any = ""
        
        if !(profileTableData[section][0].sectionData.isEmpty && profileTableData[section][0].attributedData.isEmpty) {
            if row == 0 {
                cell.showDropDown()
                
                category = profileTableData[section][row].headerData.0
                value = profileTableData[section][row].headerData.1
                
                if profileTableData[section][row].color != .label {
                    cell.statValue.textColor = profileTableData[section][row].color
                }
                
            } else {
                if !profileTableData[indexPath.section][0].attributedData.isEmpty {
                    cell.statCategory.attributedText = profileTableData[indexPath.section][0].attributedData[indexPath.row - 1].0
                    cell.statValue.text = profileTableData[indexPath.section][0].attributedData[indexPath.row - 1].1 as? String
                    
                    cell.statCategory.font = UIFont(name: "Minecraftia", size: 14.0)
                    cell.statValue.textColor = UIColor(named: "gray_label")
                    cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
                    return cell
                    
                } else {
                    
                    category = profileTableData[indexPath.section][0].sectionData[indexPath.row - 1].0
                    value = profileTableData[indexPath.section][0].sectionData[indexPath.row - 1].1
                    
                    cell.statCategory.textColor = UIColor(named: "gray_label")
                    cell.statCategory.font = UIFont.systemFont(ofSize: 14)
                    cell.statValue.textColor = UIColor(named: "gray_label")
                    cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
                }
            }
            
        } else {
            category = profileTableData[indexPath.section][indexPath.row].headerData.0
            value = profileTableData[indexPath.section][indexPath.row].headerData.1
            
            if profileTableData[indexPath.section][indexPath.row].color != .label {
                cell.statValue.textColor = profileTableData[indexPath.section][indexPath.row].color
            }
        }
        
//        if profileTableData[section][row].sectionData.isEmpty && profileTableData[section][row].attributedData.isEmpty {
//            category = profileTableData[section][row].headerData.0
//            value = profileTableData[section][row].headerData.1
//
//            if profileTableData[section][row].color != .label {
//                cell.statValue.textColor = profileTableData[section][row].color
//            }
//        } else if !profileTableData[section][row].sectionData.isEmpty || !profileTableData[section][row].attributedData.isEmpty {
//            cell.showDropDown()
//
//            category = profileTableData[section][row].headerData.0
//            value = profileTableData[section][row].headerData.1
//
//            if profileTableData[section][row].color != .label {
//                cell.statValue.textColor = profileTableData[section][row].color
//            }
//        }
//
//
//        if indexPath.row == 0 {
//            if !profileTableData[indexPath.section][indexPath.row].sectionData.isEmpty || !profileTableData[indexPath.section][indexPath.row].attributedData.isEmpty {
//                cell.showDropDown()
//            }
//
//            category = profileTableData[indexPath.section][indexPath.row].headerData.0
//            value = profileTableData[indexPath.section][indexPath.row].headerData.1
//
//            if profileTableData[indexPath.section][indexPath.row].color != .label {
//                cell.statValue.textColor = profileTableData[indexPath.section][indexPath.row].color
//            }
//
//        } else {
//
//            if !profileTableData[indexPath.section][0].attributedData.isEmpty {
//                cell.statCategory.attributedText = profileTableData[indexPath.section][0].attributedData[indexPath.row - 1].0
//                cell.statValue.text = profileTableData[indexPath.section][0].attributedData[indexPath.row - 1].1 as? String
//
//                cell.statCategory.font = UIFont(name: "Minecraftia", size: 14.0)
//                cell.statValue.textColor = UIColor(named: "gray_label")
//                cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
//                return cell
//
//            } else {
//
//                category = profileTableData[indexPath.section].sectionData[indexPath.row - 1].0
//                value = profileTableData[indexPath.section].sectionData[indexPath.row - 1].1
//
//                cell.statCategory.textColor = UIColor(named: "gray_label")
//                cell.statCategory.font = UIFont.systemFont(ofSize: 14)
//                cell.statValue.textColor = UIColor(named: "gray_label")
//                cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
//            }
//
//
//        }
        
        if value is Int {
            value = (value as! Int).withCommas
        }
        
        if value is UInt64 {
            value = (value as! UInt64).withCommas
        }
        
        cell.configure(category: category, value: "\(value)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !(profileTableData[indexPath.section][0].sectionData.isEmpty && profileTableData[indexPath.section][0].attributedData.isEmpty) {
            return indexPath.row == 0 ? 55 : 41
        }

        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !(profileTableData[indexPath.section][0].sectionData.isEmpty && profileTableData[indexPath.section][0].attributedData.isEmpty) && indexPath.row == 0 {
            profileTableData[indexPath.section][0].isOpened = !profileTableData[indexPath.section][0].isOpened
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (profileTableData[indexPath.section][0].sectionData.isEmpty && profileTableData[indexPath.section][0].attributedData.isEmpty) || indexPath.row != 0 {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var historyCount = 0
        
        if hasNameHistory {
            historyCount += 1
        }
        
        if hasRankHistory {
            historyCount += 1
            
            if section == 1 {
                return 20
            }
        }
        
        let headers = [
            historyCount: "",
            historyCount + 1: "",
            historyCount + 2: "",
            historyCount + 3: "",
            historyCount + 4: "",
            historyCount + 5: "",
            historyCount + 6: "Status",
            historyCount + 7: "",
        ]
        
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
        var historyCount = 0
        
        if hasNameHistory {
            historyCount += 1
        }
        
        if hasRankHistory {
            historyCount += 1
        }
        
        let headers = [
            historyCount: "",
            historyCount + 1: "",
            historyCount + 2: "",
            historyCount + 3: "",
            historyCount + 4: "",
            historyCount + 5: "",
            historyCount + 6: "Status",
            historyCount + 7: "",
        ]
        
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
        return CGFloat.leastNormalMagnitude
    }
    
    func getNameHistory() -> [(String, Any)] {
        if data["knownAliases"].arrayValue.count == 0 {
            return []
        }
        
        var nameList: [(String, Any)] = []
        
        for name in data["knownAliases"].arrayValue.reversed() {
            nameList.append((name.stringValue, ""))
        }
        
        return nameList
    }
    
    func getRankHistory() -> [(NSMutableAttributedString, Any)] {
        let levelUps = [
            ("levelUp_VIP", "VIP"),
            ("levelUp_VIP_PLUS", "VIP_PLUS"),
            ("levelUp_MVP", "MVP"),
            ("levelUp_MVP_PLUS", "MVP_PLUS")
        ]
        
        var ret: [(NSMutableAttributedString, Any)] = []
        
        for levelUp in levelUps {
            if data[levelUp.0].exists() {
                let attributedString = RankManager.getAttributedStringForPurchasedRank(data: data, rankID: levelUp.1)
                
                let dateString = Utils.convertToDateStringFormat(milliseconds: data[levelUp.0].uInt64Value)
                
                ret.append((attributedString, dateString))
            }
        }
        
        return ret
    }
    
    func getNetworkLevel() -> Double {
        let xp = data["networkExp"].doubleValue
        
        var level = sqrt(Double(xp) + 15312.5) - (125.0 / sqrt(2))
        level /= (25.0 * sqrt(2))

        return level
        
    }
    
    func getXPToNextLevel(currentXP: UInt64) -> UInt64 {
        let currentLevel = getNetworkLevel()
        let targetLevel = floor(currentLevel) + 1
        
        let neededXP = (2500 * pow(targetLevel + 2.5, 2)) / 2 - 15312.5
        
        return UInt64(neededXP) - currentXP
    }
    
    func getQuestsCompleted() -> Int {
        var questsCompleted = 0
        
        for (_, subJSON):(String, JSON) in data["quests"] {
            questsCompleted += subJSON["completions"].arrayValue.count
        }
        
        return questsCompleted
    }
    
    func getChallengesCompleted() -> Int {
        var challengesCompleted = 0
        
        for (_,subJson):(String, JSON) in data["challenges"]["all_time"] {
            challengesCompleted += subJson.intValue
        }
        
        return challengesCompleted
    }
    
    func getTotalCoins() -> UInt64 {
        var totalCoins: UInt64 = 0
        
        for (key, _) in GameTypes.databaseNameToCleanName {
            totalCoins &+= data["stats"][key]["coins"].uInt64Value
        }
        
        return totalCoins
    }
    
    func getTotalWins() -> Int {
        var totalWins = 0
        
        for path in CumulativeStatsKeys.totalWinsKeys {
            totalWins += data[path].intValue
        }
        
        return totalWins
    }
    
    func getTotalKills() -> Int {
        var totalKills = 0
        
        for path in CumulativeStatsKeys.totalKillsKeys {
            totalKills += data[path].intValue
        }
        
        return totalKills
    }
    
    func dailyRewardClaimed() -> Bool {
        if !data["eugene"]["dailyTwoKExp"].exists() {
            return false
        }
        
        let milliseconds = data["eugene"]["dailyTwoKExp"].uInt64Value
        let secondsSince1970 = milliseconds / 1000
        
        let dateClaimed = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        let currentDate = Date()
        
        let dateClaimedComponents = NSCalendar.current.dateComponents(in: TimeZone(abbreviation: "EST")!, from: dateClaimed)
        let currentDateComponents = NSCalendar.current.dateComponents(in: TimeZone(abbreviation: "EST")!, from: currentDate)
        
        return dateClaimedComponents.year == currentDateComponents.year && dateClaimedComponents.month == currentDateComponents.month && dateClaimedComponents.day == currentDateComponents.day
    }
    
    func getCoinMultiplier() -> String {
        let rankMultipliers = [
            "VIP": (value: 2, name: "VIP"),
            "VIP_PLUS": (value: 3, name: "VIP+"),
            "MVP": (value: 4, name: "MVP"),
            "MVP_PLUS": (value: 5, name: "MVP+"),
            "YOUTUBER": (value: 7, name: "YouTuber"),
        ]
        
        let levelMultipliers = [
            (level: 0, value: 1),
            (level: 5, value: 1.5),
            (level: 10, value: 2),
            (level: 15, value: 2.5),
            (level: 20, value: 3),
            (level: 25, value: 3.5),
            (level: 30, value: 4),
            (level: 40, value: 4.5),
            (level: 50, value: 5),
            (level: 100, value: 5.5),
            (level: 125, value: 6),
            (level: 150, value: 6.5),
            (level: 200, value: 7),
            (level: 250, value: 8),
        ]
        
        var multiplier = 1.0
        let level = getNetworkLevel()
        let rank = RankManager.getRank(data: data)
        var name = ""
        
        for m in levelMultipliers.reversed() {
            if level >= Double(m.level) {
                multiplier = m.value
                name = "(Level \(Int(level)))"
                break
            }
        }
        
        if data["eulaCoins"].boolValue || rank == "YOUTUBER" {
            if let rankMultiplier = rankMultipliers[rank] {
                if Double(rankMultiplier.value) > multiplier {
                    multiplier = Double(rankMultiplier.value)
                    name = "(\(rankMultiplier.name))"
                }
            }
        }
        
        return "x" + String(format: "%.1f", multiplier) + " " + name
    }
    
    func getOnlineStatus() -> (String, UIColor) {
        
        if MinecraftUser.shared.isOnline {
            return ("Online", .systemGreen)
        }
        
        if !data["firstLogin"].exists() && !data["lastLogin"].exists() {
            return ("Never logged into Hypixel :(", UIColor.LabelColors.grayLabel)
        }
        
        //Some people just don't have last login/logout records (thanks Hypixel)
        if data["firstLogin"].exists() && !data["lastLogin"].exists() && !data["lastLogout"].exists() {
            return ("Offline", .systemRed)
        }
        
        //Sometimes last login exists but last logout doesn't, even if the player is online
        if data["lastLogin"].exists() && !data["lastLogout"].exists() {
            let lastLogin = Utils.convertToDate(milliseconds: data["lastLogin"].uInt64Value)
            
            return ("Offline (Last seen \(lastLogin.timeAgoDisplay()))", .systemRed)
        }
        
        //Sometimes status endpoint doesn't update properly. If the user's last login is more recent than last logout, they must be online
        if data["lastLogin"].uInt64Value > data["lastLogout"].uInt64Value {
            MinecraftUser.shared.gameType = GameTypes.allGames[data["mostRecentGameType"].stringValue]?.cleanName ?? "-"
            return ("Online", .systemGreen)
        }
        
        let lastLogoff = Utils.convertToDate(milliseconds: data["lastLogout"].uInt64Value)
        
        return ("Offline (Last seen \(lastLogoff.timeAgoDisplay()))", .systemRed)
    }
}
