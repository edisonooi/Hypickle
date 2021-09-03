//
//  StatsInfoTableViewCell.swift
//  HypixelStats
//
//  Created by codeplus on 7/20/21.
//

import UIKit

class StatsInfoTableViewCell: UITableViewCell {
    
    static let identifier = "StatsInfoTableViewCell"
    @IBOutlet weak var dropDownIcon: UIImageView!
    @IBOutlet weak var dropDownIconWidth: NSLayoutConstraint!
    
    @IBOutlet weak var statCategory: UILabel!
    @IBOutlet weak var statValue: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "StatsInfoTableViewCell", bundle: nil)
    }
    
    public func configure(category: String, value: String) {
        statCategory.text = category
        statValue.text = value
    }
    
    override func prepareForReuse() {
        self.statCategory.textColor = .label
        self.statCategory.font = UIFont.systemFont(ofSize: 17)
        self.statValue.textColor = .label
        self.statValue.font = UIFont.boldSystemFont(ofSize: 17)
        self.dropDownIconWidth.constant = 0.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownIconWidth.constant = 0.0
    }
    
    func showDropDown() {
        self.dropDownIconWidth.constant = 17
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
