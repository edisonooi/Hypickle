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
    
    var selectedOneTimeSortingRow = 0
    //var selectedTieredSortingRow = 0
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

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
            let description = currentAchievement.achievementDescription
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100
        case 1:
            return 100
        default:
            return CGFloat.leastNormalMagnitude
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = SortTableHeaderView.instanceFromNib()
            headerView.headerLabel.text = "Tiered Achievements"
            headerView.sortButton.isHidden = true
//            headerView.sortButton.addTarget(self, action: #selector(sortTieredButtonTapped), for: .touchUpInside)
//            headerView.sortButton.titleLabel?.text = "Sorted: " + getShortSortingCategoryName(category: TieredSortingCategory.allCases[selectedTieredSortingRow])
            return headerView
        case 1:
            let headerView = SortTableHeaderView.instanceFromNib()
            headerView.headerLabel.text = "One-Time Achievements"
            headerView.sortButton.addTarget(self, action: #selector(sortOneTimeButtonTapped), for: .touchUpInside)
            headerView.sortButton.titleLabel?.text = "Sorted: " + getShortSortingCategoryName(category: OneTimeSortingCategory.allCases[selectedOneTimeSortingRow])
            return headerView
        default:
            return nil
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
