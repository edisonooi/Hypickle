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
    
    var user: MinecraftUser?
    var allStatsData: JSON = ["": ""]
    
    
    @IBOutlet weak var gameTableContainerView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var gameStats: JSON = [:]
    
    
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var skinImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = user?.username {
            usernameTextField.text = username
            self.tabBarController?.navigationItem.title = username + "'s Stats"
        } else {
            self.tabBarController?.navigationItem.title = "No User Found"
        }
        
        self.tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        mainScrollView.delegate = self
        
        if let skinURL = user?.skin, skinURL != "" {
            downloadSkinImage(from: URL(string: skinURL)!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.tabBarController?.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
            navigationController.followScrollView(mainScrollView, delay: 50.0)
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
            let tabBar = tabBarController as! PlayerInfoTabBarController
            self.user = tabBar.user
            self.allStatsData = tabBar.user!.playerHypixelData
            
            gamesTableVC.data = self.allStatsData["stats"]
        }
    }
    
    func downloadSkinImage(from url: URL) {
        
        APIManager.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.skinImageView.image = UIImage(data: data)
            }
        }
    }

}
