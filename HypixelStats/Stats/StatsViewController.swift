//
//  StatsViewController.swift
//  HypixelStats
//
//  Created by codeplus on 7/16/21.
//

import UIKit
import SwiftyJSON
import AMScrollingNavbar

class StatsViewController: UIViewController, UIScrollViewDelegate {

    var allStatsData: JSON = ["": ""]
    
    @IBOutlet weak var gameTableContainerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MinecraftUser.shared.username != "" {
            usernameTextField.attributedText = RankManager.getAttributedStringForRank(data: allStatsData)
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
            self.tabBarController?.navigationItem.title = MinecraftUser.shared.username + "'s Stats"
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showGamesTable" {
            let gamesTableVC = segue.destination as! GamesTableController
            
            gamesTableVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            //Initializing stuff here because apparently this is the first method that gets called
            self.allStatsData = MinecraftUser.shared.playerHypixelData
            
            gamesTableVC.data = self.allStatsData
        }
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
