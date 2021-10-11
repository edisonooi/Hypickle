//
//  AchievementPercentageTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/8/21.
//

import UIKit

class AchievementPercentageTableViewCell: UITableViewCell {

    static let identifier = "AchievementPercentageTableViewCell"
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var achievementLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "AchievementPercentageTableViewCell", bundle: nil)
    }
    
    public func configure(game: String, achievementName: String, percentage: String) {
        gameLabel.text = game
        achievementLabel.text = achievementName
        percentageLabel.text = percentage
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
