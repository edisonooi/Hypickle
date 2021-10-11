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
    @IBOutlet weak var pointsRatioLabel: UILabel!
    @IBOutlet weak var capsuleImageView: UIImageView!
    
    @IBOutlet weak var pointsLabel1: UILabel!
    @IBOutlet weak var pointsLabel2: UILabel!
    @IBOutlet weak var pointsLabel3: UILabel!
    @IBOutlet weak var pointsLabel4: UILabel!
    @IBOutlet weak var pointsLabel5: UILabel!
    
    @IBOutlet weak var pointsLabel1Height: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel2Height: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel3Height: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel4Height: NSLayoutConstraint!
    @IBOutlet weak var pointsLabel5Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var amountLabel1: UILabel!
    @IBOutlet weak var amountLabel2: UILabel!
    @IBOutlet weak var amountLabel3: UILabel!
    @IBOutlet weak var amountLabel4: UILabel!
    @IBOutlet weak var amountLabel5: UILabel!
    
    
    
    static func nib() -> UINib {
        return UINib(nibName: "TieredAchievementTableViewCell", bundle: nil)
    }
    
    public func configure(name: String, description: String, tiers: [AchievementTier], numCompletedTiers: Int, completedAmount: Int) {
        nameLabel.text = name
        
        //Format description string with current progress
        var nextCompletionAmount = ""
        
        if numCompletedTiers == tiers.count {
            nextCompletionAmount = tiers[tiers.count - 1].amount.withCommas
        } else {
            nextCompletionAmount = tiers[numCompletedTiers].amount.withCommas
        }

        let amountCompletedString = completedAmount.withCommas + "/" + nextCompletionAmount
        
        let description2 = description.replacingOccurrences(of: "%s", with: amountCompletedString)
        
        let descriptionString = NSMutableAttributedString(string: description2)
        
        let range = descriptionString.mutableString.range(of: amountCompletedString, options: .caseInsensitive)
        
        descriptionString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: range)
        descriptionString.addAttribute(.backgroundColor, value: UIColor.systemGray, range: range)
        
        descriptionLabel.attributedText = descriptionString
        
        //Format ratio label in top right with color
        var earnedPoints = 0
        var totalPoints = 0
        
        for i in 0..<tiers.count {
            let pointsForThisTier = tiers[i].points
            
            totalPoints += pointsForThisTier
            
            if numCompletedTiers > i {
                earnedPoints += pointsForThisTier
            }
        }
        
        pointsRatioLabel.text = "\(earnedPoints)/\(totalPoints)"
        
        if numCompletedTiers == 0 {
            capsuleImageView.tintColor = .systemRed
        } else if numCompletedTiers > 0 && numCompletedTiers < tiers.count {
            capsuleImageView.tintColor = .systemYellow
        } else {
            capsuleImageView.tintColor = .systemGreen
        }
        
        //Format all tiers
        
        let pointsLabels: [UILabel] = [pointsLabel1, pointsLabel2, pointsLabel3, pointsLabel4, pointsLabel5]
        let pointsLabelsHeights: [NSLayoutConstraint] = [pointsLabel1Height, pointsLabel2Height, pointsLabel3Height, pointsLabel4Height, pointsLabel5Height]
        let amountLabels: [UILabel] = [amountLabel1, amountLabel2, amountLabel3, amountLabel4, amountLabel5]
        
        let numTiers = tiers.count
        
        var startIndex = 0
        if numTiers < 5 {
            for i in 0..<5 - numTiers {
                pointsLabelsHeights[i].constant = 0.0
            }
            
            startIndex = 5 - numTiers
        }
        
        for (i, tier) in tiers.enumerated() {
            pointsLabels[i + startIndex].text = String(tier.points)
            amountLabels[i + startIndex].text = tier.amount.withCommas
            
            var tintColor: UIColor = .systemRed
            
            if numCompletedTiers == i {
                tintColor = .systemYellow
            } else if numCompletedTiers > i {
                tintColor = .systemGreen
            }
            
            pointsLabels[i + startIndex].textColor = tintColor
            amountLabels[i + startIndex].textColor = tintColor
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
