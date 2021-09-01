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
    
    var data: JSON = [:]
    var user: MinecraftUser?
    
    var hasNameHistory: Bool = true
    var hasRankHistory: Bool = true
    

    @IBOutlet var profileTable: NonScrollingTable!
    
    lazy var profileTableData: [CellData] = {
        var ret: [CellData] = []
        
        var nameHistory = getNameHistory()
        var rankHistory = getRankHistory()
        
        if !nameHistory.isEmpty {
            ret.append(CellData(headerData: ("Name History", ""), sectionData: nameHistory))
        } else {
            hasNameHistory = false
        }
        
        if !rankHistory.isEmpty {
            ret.append(CellData(headerData: ("Rank History", ""), attributedData: rankHistory))
        } else {
            hasRankHistory = false
        }
        
        var didClaimReward = dailyRewardClaimed()
        var claimedString = didClaimReward ? "Claimed!" : "Not Claimed"
        var claimedColor = didClaimReward ? UIColor.systemGreen : UIColor.systemRed
        
        var onlineStatus = getOnlineStatus()
        
        var generalStats =  [
            
            CellData(headerData: ("Network Level", String(format: "%.2f", getNetworkLevel())), color: UIColor(named: "mc_cyan")!),
            CellData(headerData: ("Total EXP", data["networkExp"].uInt64Value), color: UIColor(named: "mc_cyan")!),
            CellData(headerData: ("EXP to Next Level", getXPToNextLevel(currentXP: data["networkExp"].uInt64Value)), color: UIColor(named: "mc_cyan")!),
            
            CellData(headerData: ("Karma", data["karma"].intValue), color: UIColor(named: "mc_light_purple")!),
            CellData(headerData: ("Achievement Points", data["achievementPoints"].intValue), color: UIColor(named: "mc_yellow")!),
            CellData(headerData: ("Quests Completed", getQuestsCompleted()), color: UIColor(named: "mc_green")!),
            CellData(headerData: ("Challenges Completed", getChallengesCompleted()), color: UIColor(named: "mc_green")!),
            
            CellData(headerData: ("Coin Multiplier", getCoinMultiplier())),
            CellData(headerData: ("Total Coins", getTotalCoins()), color: UIColor(named: "mc_gold")!),
            
            CellData(headerData: ("Total Wins", getTotalWins())),
            CellData(headerData: ("Total Kills", getTotalKills())),
            
            CellData(headerData: ("Daily Reward", claimedString), color: claimedColor),
            CellData(headerData: ("Rewards Claimed", data["totalRewards"].intValue)),
            CellData(headerData: ("Current Streak", data["rewardScore"].intValue)),
            CellData(headerData: ("Highest Streak", data["rewardHighScore"].intValue)),
            
            CellData(headerData: ("Ranks Gifted", data["giftingMeta"]["ranksGiven"].intValue), color: UIColor(named: "mc_dark_purple")!),
            CellData(headerData: ("Gifts Given", data["giftingMeta"]["bundlesGiven"].intValue), color: UIColor(named: "mc_light_purple")!),
            CellData(headerData: ("Gifts Received", data["giftingMeta"]["bundlesReceived"].intValue), color: UIColor(named: "mc_light_purple")!),
            
            CellData(headerData: ("Status", onlineStatus.0), color: onlineStatus.1),
            CellData(headerData: ("Game", self.user!.gameType)),
            
        ]
        
        ret.append(contentsOf: generalStats)
        
        if data["firstLogin"].exists() {
            var loginHistory = [
                CellData(headerData: ("First Login", Utils.convertToDateStringFormat(milliseconds: data["firstLogin"].uInt64Value))),
                CellData(headerData: ("Last Login", Utils.convertToDateStringFormat(milliseconds: data["lastLogin"].uInt64Value))),
                CellData(headerData: ("Last Logout", Utils.convertToDateStringFormat(milliseconds: data["lastLogout"].uInt64Value))),
            ]
            
            ret.append(contentsOf: loginHistory)
        }
        
        return ret
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        profileTable.dataSource = self
        profileTable.estimatedRowHeight = 0
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return profileTableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if profileTableData[section].isOpened {
            return profileTableData[section].sectionData.count == 0 ? profileTableData[section].attributedData.count + 1 : profileTableData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
        
        var category = ""
        var value: Any = ""
        
        if indexPath.row == 0 {
            category = profileTableData[indexPath.section].headerData.0
            value = profileTableData[indexPath.section].headerData.1
            
            if profileTableData[indexPath.section].color != .label {
                cell.statValue.textColor = profileTableData[indexPath.section].color
            }
            
        } else {
            
            if !profileTableData[indexPath.section].attributedData.isEmpty {
                cell.statCategory.attributedText = profileTableData[indexPath.section].attributedData[indexPath.row - 1].0
                cell.statValue.text = profileTableData[indexPath.section].attributedData[indexPath.row - 1].1 as? String
                
                cell.statCategory.font = UIFont(name: "Minecraftia", size: 14.0)
                cell.statValue.textColor = UIColor(named: "gray_label")
                cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
                return cell
                
            } else {
                
                category = profileTableData[indexPath.section].sectionData[indexPath.row - 1].0
                value = profileTableData[indexPath.section].sectionData[indexPath.row - 1].1
                
                cell.statCategory.textColor = UIColor(named: "gray_label")
                cell.statCategory.font = UIFont.systemFont(ofSize: 14)
                cell.statValue.textColor = UIColor(named: "gray_label")
                cell.statValue.font = UIFont.boldSystemFont(ofSize: 14)
            }
            
            
        }
        
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
        if indexPath.row == 0 {
            return 44
        }

        return 41
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (!profileTableData[indexPath.section].sectionData.isEmpty || !profileTableData[indexPath.section].attributedData.isEmpty) && indexPath.row == 0 {
            profileTableData[indexPath.section].isOpened = !profileTableData[indexPath.section].isOpened
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (profileTableData[indexPath.section].sectionData.isEmpty && profileTableData[indexPath.section].attributedData.isEmpty) || indexPath.row != 0 {
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
        }
        
        let headers = [
            historyCount: "",
            historyCount + 3: "",
            historyCount + 7: "",
            historyCount + 9: "",
            historyCount + 11: "",
            historyCount + 15: "",
            historyCount + 18: "Status",
            historyCount + 20: "",
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
            historyCount + 3: "",
            historyCount + 7: "",
            historyCount + 9: "",
            historyCount + 11: "",
            historyCount + 15: "",
            historyCount + 18: "Status",
            historyCount + 20: "",
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
            totalCoins += data["stats"][key]["coins"].uInt64Value
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
        
        if self.user!.isOnline {
            return ("Online", .systemGreen)
        }
        
        if !data["firstLogin"].exists() {
            return ("Never logged into Hypixel :(", UIColor(named: "gray_label")!)
        }
        
        //Sometimes status endpoint doesn't update properly. If the user's last login is more recent than last logout, they must be online
        if data["lastLogin"].uInt64Value > data["lastLogout"].uInt64Value {
            self.user?.gameType = GameTypes.allGames[data["mostRecentGameType"].stringValue]?.cleanName ?? "-"
            return ("Online", .systemGreen)
        }
        
        let lastLogoff = Utils.convertToDate(milliseconds: data["lastLogout"].uInt64Value)
        
        return ("Offline (Last seen \(lastLogoff.timeAgoDisplay()))", .systemRed)
    }
}
