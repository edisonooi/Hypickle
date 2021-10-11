//
//  OneTimeAchievementTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/11/21.
//

import UIKit

class OneTimeAchievementTableViewCell: UITableViewCell {

    static let identifier = "OneTimeAchievementTableViewCell"
    
    
    static func nib() -> UINib {
        return UINib(nibName: "OneTimeAchievementTableViewCell", bundle: nil)
    }
    
    public func configure() {
        
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
