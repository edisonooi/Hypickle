//
//  ProfileTableViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/30/21.
//

import UIKit
import SwiftyJSON

class ProfileTableViewController: UITableViewController {
    
    var data: JSON = [:]
    
    let headers = [
        0: ""
    ]

    @IBOutlet var profileTable: UITableView!
    
    lazy var profileTableData: [CellData] = {
        var ret: [CellData] = []
        
        
        
        return  [
            CellData(headerData: ("Name History", ""), sectionData: getNameHistory()),
            CellData(headerData: ("Rank History", ""), attributedData: getRankHistory())
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        profileTable.dataSource = self
        profileTable.allowsSelection = true
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
                cell.statValue.text = profileTableData[indexPath.section].attributedData[indexPath.row - 1].1 as! String
                
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
        return CGFloat.leastNormalMagnitude
    }
    
    func getNameHistory() -> [(String, Any)] {
        if data["knownAliases"].arrayValue.count == 0 {
            return []
        }
        
        var nameList: [(String, Any)] = []
        
        for name in data["knownAliases"].arrayValue {
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
                var attributedString = RankManager.getAttributedStringForRank(data: data, rankID: levelUp.1)
                
                var dateString = Utils.convertToDateFormat(milliseconds: data[levelUp.0].uInt64Value)
                
                ret.append((attributedString, dateString))
            }
        }
        
        return ret
    }


}
