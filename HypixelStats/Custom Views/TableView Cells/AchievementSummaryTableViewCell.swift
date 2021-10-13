//
//  AchievementSummaryTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/13/21.
//

import UIKit

class AchievementSummaryTableViewCell: UITableViewCell {

    static let identifier = "AchievementSummaryTableViewCell"
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsPercentLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countPercentLabel: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "AchievementSummaryTableViewCell", bundle: nil)
    }
    
    public func configure(points: NSAttributedString, pointsPercent: NSAttributedString, count: NSAttributedString, countPercent: NSAttributedString) {
        pointsLabel.attributedText = points
        pointsPercentLabel.attributedText = pointsPercent
        countLabel.attributedText = count
        countPercentLabel.attributedText = countPercent
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
