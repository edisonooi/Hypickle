//
//  GameAchievementsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/10/21.
//

import UIKit
import AMScrollingNavbar

//TODO: Figure out how to sort by completed/incomplete

enum OneTimeSortingCategory: String, CaseIterable {
    case alphabetical = "Alphabetical (A to Z)"
    case pointsAscending = "Points (Low to High)"
    case pointsDescending = "Points (High to Low)"
    case gamePercentAscending = "Game % Unlocked (Low to High)"
    case gamePercentDescending = "Game % Unlocked (High to Low)"
    case globalPercentAscending = "Global % Unlocked (Low to High)"
    case globalPercentDescending = "Global % Unlocked (High to Low)"
}

//enum TieredSortingCategory: String, CaseIterable {
//    case alphabetical = "Alphabetical (A to Z)"
//}

class GameAchievementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var achievementGameID: String = ""
    var achievements: AchievementGroup?
    var completedAchievements: CompletedAchievementGroup?
    
    var oneTimeAchievementsSorted: [(String, OneTimeAchievement)] = []
    var tieredAchievementsSorted: [(String, TieredAchievement)] = []
    
    var legacyOneTimeAchievementsSorted: [(String, OneTimeAchievement)] = []
    var legacyTieredAchievementsSorted: [(String, TieredAchievement)] = []
    
    var selectedOneTimeSortingRow = 0
    //var selectedTieredSortingRow = 0
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var expandedSections = [
        0: false,
        1: true,
        2: true,
        3: true,
        4: true
    ]
    
    var hasTiered: Bool = true
    var hasOneTimes: Bool = true
    var hasTieredLegacy: Bool = false
    var hasTieredOneTime: Bool = false

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
            
            legacyOneTimeAchievementsSorted = safeAchievements.legacyOneTimeAchievements.sorted {
                $0.1.name < $1.1.name
            }
            
            legacyTieredAchievementsSorted = safeAchievements.legacyTieredAchievements.sorted {
                $0.1.name < $1.1.name
            }
        }
        
        hasTiered = tieredAchievementsSorted.count > 0
        hasOneTimes = oneTimeAchievementsSorted.count > 0
        hasTieredLegacy = legacyTieredAchievementsSorted.count > 0
        hasTieredOneTime = legacyOneTimeAchievementsSorted.count > 0
        
        achievementsTable.register(OneTimeAchievementTableViewCell.nib(), forCellReuseIdentifier: OneTimeAchievementTableViewCell.identifier)
        achievementsTable.register(TieredAchievementTableViewCell.nib(), forCellReuseIdentifier: TieredAchievementTableViewCell.identifier)
        achievementsTable.register(StatsInfoTableViewCell.nib(), forCellReuseIdentifier: StatsInfoTableViewCell.identifier)
        achievementsTable.sectionFooterHeight = 16
        achievementsTable.dataSource = self
        achievementsTable.delegate = self
        achievementsTable.allowsSelection = true
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if !hasTiered {
                return 0
            } else if (expandedSections[section] ?? false) {
                return tieredAchievementsSorted.count + 1
            } else {
                return 1
            }
        case 2:
            if !hasOneTimes {
                return 0
            } else if (expandedSections[section] ?? false) {
                return oneTimeAchievementsSorted.count + 1
            } else {
                return 1
            }
        case 3:
            if !hasTieredLegacy {
                return 0
            } else if (expandedSections[section] ?? false) {
                return legacyTieredAchievementsSorted.count + 1
            } else {
                return 1
            }
        case 4:
            if !hasTieredOneTime {
                return 0
            } else if (expandedSections[section] ?? false) {
                return legacyOneTimeAchievementsSorted.count + 1
            } else {
                return 1
            }
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 2 || indexPath.section == 4 {
            if indexPath.row == 0 {
                let topCell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
                topCell.showDropDown()
                topCell.statCategory.textColor = .secondaryLabel
                let labelText = (expandedSections[indexPath.section] ?? false) ? "Collapse" : "Expand"
                topCell.configure(category: labelText, value: "")
                return topCell
            }
            
            let oneTimeAchievementCell = tableView.dequeueReusableCell(withIdentifier: OneTimeAchievementTableViewCell.identifier, for: indexPath) as! OneTimeAchievementTableViewCell
            
            let currentAchievement = indexPath.section == 2 ? oneTimeAchievementsSorted[indexPath.row - 1].1 : legacyOneTimeAchievementsSorted[indexPath.row - 1].1
            
            let name = currentAchievement.name
            let shortName = GameTypes.achievementGameIDToShortName[currentAchievement.gameID] ?? "-"
            let description = currentAchievement.achievementDescription
            let points = currentAchievement.points
            let gamePercentUnlocked = currentAchievement.gamePercentUnlocked
            let globalPercentUnlocked = currentAchievement.globalPercentUnlocked
            
            var isComplete: Bool = false
            
            if let completed = completedAchievements {
                isComplete = indexPath.section == 2 ? completed.oneTimesCompleted.contains(oneTimeAchievementsSorted[indexPath.row - 1].0) : completed.legacyOneTimesCompleted.contains(legacyOneTimeAchievementsSorted[indexPath.row - 1].0)
            }
            
            oneTimeAchievementCell.configure(name: name, description: description, shortName: shortName, points: points, gamePercentage: gamePercentUnlocked, globalPercentage: globalPercentUnlocked, isComplete: isComplete)
            
            return oneTimeAchievementCell
        }
        
        else if indexPath.section == 1 || indexPath.section == 3 {
            if indexPath.row == 0 {
                let topCell = tableView.dequeueReusableCell(withIdentifier: StatsInfoTableViewCell.identifier, for: indexPath) as! StatsInfoTableViewCell
                topCell.showDropDown()
                topCell.statCategory.textColor = .secondaryLabel
                let labelText = (expandedSections[indexPath.section] ?? false) ? "Collapse" : "Expand"
                topCell.configure(category: labelText, value: "")
                return topCell
            }
            
            let tieredAchievementCell = tableView.dequeueReusableCell(withIdentifier: TieredAchievementTableViewCell.identifier, for: indexPath) as! TieredAchievementTableViewCell
            
            let currentAchievement = indexPath.section == 1 ? tieredAchievementsSorted[indexPath.row - 1].1 : legacyTieredAchievementsSorted[indexPath.row - 1].1
            let name = currentAchievement.name
            let description = currentAchievement.achievementDescription
            let tiers = currentAchievement.tiers
            var numCompletedTiers = 0
            var completedAmount = 0
            
            if indexPath.section == 1 {
                if let completedTiers = completedAchievements?.tieredCompletions {
                    let tierInfo: (Int, Int) = completedTiers[tieredAchievementsSorted[indexPath.row - 1].0] ?? (0, 0)
                    
                    numCompletedTiers = tierInfo.0
                    completedAmount = tierInfo.1
                    
                }
            } else {
                if let completedTiers = completedAchievements?.legacyTieredCompletions {
                    let tierInfo: (Int, Int) = completedTiers[legacyTieredAchievementsSorted[indexPath.row - 1].0] ?? (0, 0)
                    
                    numCompletedTiers = tierInfo.0
                    completedAmount = tierInfo.1
                    
                }
            }
            
            
            
            
            tieredAchievementCell.configure(name: name, description: description, tiers: tiers, numCompletedTiers: numCompletedTiers, completedAmount: completedAmount)
            
            return tieredAchievementCell
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return hasTiered ? 64 : 0
        case 2:
            return hasOneTimes ? 100 : 0
        case 3:
            return hasTieredOneTime || hasTieredLegacy ? 64 : 0
        case 4:
            return 20
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            if !hasTiered {
                return nil
            }
            
            let headerView = GenericHeaderView.instanceFromNib()
            headerView.title.text = "Tiered Achievements"
//            let headerView = SortTableHeaderView.instanceFromNib()
//            headerView.headerLabel.text = "Tiered Achievements"
//            headerView.sortButton.isHidden = true
//            headerView.sortButton.addTarget(self, action: #selector(sortTieredButtonTapped), for: .touchUpInside)
//            headerView.sortButton.titleLabel?.text = "Sorted: " + getShortSortingCategoryName(category: TieredSortingCategory.allCases[selectedTieredSortingRow])
            return headerView
        case 2:
            if !hasOneTimes {
                return nil
            }
            
            let headerView = SortTableHeaderView.instanceFromNib()
            headerView.headerLabel.text = "One-Time Achievements"
            headerView.sortButton.addTarget(self, action: #selector(sortOneTimeButtonTapped), for: .touchUpInside)
            headerView.sortButton.titleLabel?.text = "Sorted: " + getShortSortingCategoryName(category: OneTimeSortingCategory.allCases[selectedOneTimeSortingRow])
            return headerView
        case 3:
            if !hasTieredLegacy && !hasTieredOneTime {
                return nil
            }
            
            let headerView = GenericHeaderView.instanceFromNib()
            headerView.title.text = "Legacy Achievements"
            
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            if let section = expandedSections[indexPath.section] {
                expandedSections[indexPath.section] = !section
            }
            
            tableView.reloadData()
            tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            //tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
//    @objc func sortTieredButtonTapped() {
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight / 5)
//        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 5))
//        pickerView.tag = 0
//        pickerView.dataSource = self
//        pickerView.delegate = self
//
//        pickerView.selectRow(selectedTieredSortingRow, inComponent: 0, animated: false)
//
//        vc.view.addSubview(pickerView)
//        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
//        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
//
//        let alert = UIAlertController(title: "Sort By...", message: "", preferredStyle: .actionSheet)
//
//        alert.setValue(vc, forKey: "contentViewController")
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
//        }))
//
//        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
//            self.selectedTieredSortingRow = pickerView.selectedRow(inComponent: 0)
//
//            let selectedCategory = TieredSortingCategory.allCases[self.selectedTieredSortingRow]
//
//            self.sortTiered(category: selectedCategory)
//
//            self.achievementsTable.reloadData()
//
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @objc func sortOneTimeButtonTapped() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight / 5)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 5))
        //pickerView.tag = 1
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedOneTimeSortingRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Sort By...", message: "", preferredStyle: .actionSheet)
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
//            let section = IndexSet.init(integer: 1)
//            self.achievementsTable.reloadSections(section, with: .none)
            self.achievementsTable.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedOneTimeSortingRow = pickerView.selectedRow(inComponent: 0)
            
            let selectedCategory = OneTimeSortingCategory.allCases[self.selectedOneTimeSortingRow]
            
            self.sortOneTimes(category: selectedCategory)
            
            self.achievementsTable.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getShortSortingCategoryName(category: OneTimeSortingCategory) -> String {
        switch category {
        case .alphabetical:
            return "A to Z"
        case .pointsAscending:
            return "Points ↑"
        case .pointsDescending:
            return "Points ↓"
        case .gamePercentAscending:
            return "Game % Unlocked ↑"
        case .gamePercentDescending:
            return "Game % Unlocked ↓"
        case .globalPercentAscending:
            return "Global % Unlocked ↑"
        case .globalPercentDescending:
            return "Global % Unlocked ↓"
        }
    }
    
//    func getShortSortingCategoryName(category: TieredSortingCategory) -> String {
//        switch category {
//        case .alphabetical:
//            return "A to Z"
//        }
//    }
    
    func sortOneTimes(category: OneTimeSortingCategory) {
        switch category {
        case .alphabetical:
            oneTimeAchievementsSorted.sort {
                $0.1.name < $1.1.name
            }
        case .pointsAscending:
            oneTimeAchievementsSorted.sort {
                $0.1.points < $1.1.points
            }
        case .pointsDescending:
            oneTimeAchievementsSorted.sort {
                $0.1.points > $1.1.points
            }
        case .gamePercentAscending:
            oneTimeAchievementsSorted.sort {
                $0.1.gamePercentUnlocked < $1.1.gamePercentUnlocked
            }
        case .gamePercentDescending:
            oneTimeAchievementsSorted.sort {
                $0.1.gamePercentUnlocked > $1.1.gamePercentUnlocked
            }
        case .globalPercentAscending:
            oneTimeAchievementsSorted.sort {
                $0.1.globalPercentUnlocked < $1.1.globalPercentUnlocked
            }
        case .globalPercentDescending:
            oneTimeAchievementsSorted.sort {
                $0.1.globalPercentUnlocked > $1.1.globalPercentUnlocked
            }
        }
        
    }
    
//    func sortTiered(category: TieredSortingCategory) {
//        switch category {
//        case .alphabetical:
//            tieredAchievementsSorted.sort {
//                $0.1.name < $1.1.name
//            }
//        }
//    }
}

extension GameAchievementsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView.tag == 0 {
//            return TieredSortingCategory.allCases.count
//        }
        
        return OneTimeSortingCategory.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView.tag == 0 {
//            return TieredSortingCategory.allCases[row].rawValue
//        }
        
        return OneTimeSortingCategory.allCases[row].rawValue
    }
}
