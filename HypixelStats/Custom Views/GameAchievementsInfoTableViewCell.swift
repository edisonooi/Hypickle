//
//  GameAchievementsInfoTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/8/21.
//

import UIKit

class GameAchievementsInfoTableViewCell: UITableViewCell {

    static let identifier = "GameAchievementsInfoTableViewCell"
    
    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "GameAchievementsInfoTableViewCell", bundle: nil)
    }
    
    public func configure(icon: String, name: String, pointsRatio: NSAttributedString, percentage: NSAttributedString) {
        gameIcon.image = UIImage(named: icon)
        gameName.text = name
        pointsLabel.attributedText = pointsRatio
        percentageLabel.attributedText = percentage
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
