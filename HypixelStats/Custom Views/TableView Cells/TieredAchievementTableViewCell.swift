//
//  TieredAchievementTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/11/21.
//

import UIKit

class TieredAchievementTableViewCell: UITableViewCell {

    static let identifier = "TieredAchievementTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var capsuleImageView: UIImageView!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "TieredAchievementTableViewCell", bundle: nil)
    }
    
    public func configure(name: String, description: String, tiers: [AchievementTier], numCompletedTiers: Int, completedAmount: Int) {
        nameLabel.text = name
        
        
        
        var nextCompletionAmount = ""
        
        if numCompletedTiers == tiers.count {
            nextCompletionAmount = tiers[tiers.count - 1].amount.withCommas
        } else {
            nextCompletionAmount = tiers[numCompletedTiers].amount.withCommas
        }

        let amountCompletedString = completedAmount.withCommas + "/" + nextCompletionAmount
        
        let description2 = description.replacingOccurrences(of: "%s", with: amountCompletedString)
        print(description2)
        
        let descriptionString = NSMutableAttributedString(string: description2)
        
        let range = descriptionString.mutableString.range(of: amountCompletedString, options: .caseInsensitive)
        
        descriptionString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: range)
        descriptionString.addAttribute(.backgroundColor, value: UIColor.systemGray, range: range)
        
        descriptionLabel.attributedText = descriptionString
        
        var earnedPoints = 0
        var totalPoints = 0
        
        for i in 0..<tiers.count {
            let pointsForThisTier = tiers[i].points
            
            totalPoints += pointsForThisTier
            
            if numCompletedTiers > i {
                earnedPoints += pointsForThisTier
            }
        }
        
        pointsLabel.text = "\(earnedPoints)/\(totalPoints)"
        
        if numCompletedTiers == 0 {
            capsuleImageView.tintColor = .systemRed
        } else if numCompletedTiers > 0 && numCompletedTiers < tiers.count {
            capsuleImageView.tintColor = .systemYellow
        } else {
            capsuleImageView.tintColor = .systemGreen
        }
        
        
        
        
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
