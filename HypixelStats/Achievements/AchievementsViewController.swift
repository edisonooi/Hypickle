//
//  AchievementsViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/17/21.
//

import UIKit
import SwiftyJSON
import AMScrollingNavbar

class AchievementsViewController: UIViewController, UIScrollViewDelegate {

    var allStatsData: JSON = [:]
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MinecraftUser.shared.username != "" {
            usernameLabel.attributedText = RankManager.getAttributedStringForRank(data: allStatsData)
        }
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "   ", style: .plain, target: nil, action: nil)
        
        mainScrollView.delegate = self
        
        if MinecraftUser.shared.uuid != "" {
            downloadHeadImage(uuid: MinecraftUser.shared.uuid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.tabBarController?.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.followScrollView(mainScrollView, delay: 20.0)
        }
        
        if MinecraftUser.shared.username != "" {
            self.tabBarController?.navigationItem.title = MinecraftUser.shared.username + "'s Achievements"
        } else {
            self.tabBarController?.navigationItem.title = "No User Found"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.tabBarController?.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.stopFollowingScrollView()
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = self.tabBarController?.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar()
        }
        return true
    }
    
    func downloadHeadImage(uuid: String) {

        APIManager.getHeadFromUUID(uuid: uuid) { data, response, error in
            guard let data = data, error == nil else { return }

            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.headImageView.image = UIImage(data: data)
            }
        }
    }
    

    

}
