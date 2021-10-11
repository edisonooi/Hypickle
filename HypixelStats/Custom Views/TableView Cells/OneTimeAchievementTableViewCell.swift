//
//  OneTimeAchievementTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/11/21.
//

import UIKit

class OneTimeAchievementTableViewCell: UITableViewCell {

    static let identifier = "OneTimeAchievementTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gamePlayersUnlockedLabel: UILabel!
    @IBOutlet weak var globalPlayersUnlockedLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var gamePercentageLabel: UILabel!
    @IBOutlet weak var globalPercentageLabel: UILabel!
    
    @IBOutlet weak var gamePlayersUnlockedLabelHeight: NSLayoutConstraint!
    
    static func nib() -> UINib {
        return UINib(nibName: "OneTimeAchievementTableViewCell", bundle: nil)
    }
    
    public func configure(name: String, description: String, shortName: String, points: Int, gamePercentage: Double, globalPercentage: Double, isComplete: Bool) {
        nameLabel.text = name
        descriptionLabel.text = description
        gamePlayersUnlockedLabel.text = shortName + " Players Unlocked:"
        pointsLabel.text = String(points)
        globalPercentageLabel.text = String(format: "%.2f%%", globalPercentage)
        gamePercentageLabel.text = String(format: "%.2f%%", gamePercentage)
        
        if gamePercentage == 0.0 {
            gamePlayersUnlockedLabelHeight.constant = 0.0
            gamePercentageLabel.isHidden = true
        }
        
        circleImageView.tintColor = isComplete ? .systemGreen : .systemRed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
