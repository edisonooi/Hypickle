//
//  StatsInfoTableViewCell.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit

class StatsInfoTableViewCell: UITableViewCell {
    
    static let identifier = "StatsInfoTableViewCell"
    
    @IBOutlet weak var statCategory: UILabel!
    @IBOutlet weak var statValue: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "StatsInfoTableViewCell", bundle: nil)
    }
    
    public func configure(category: String, value: String) {
        statCategory.text = category
        statValue.text = value
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
