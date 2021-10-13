//
//  SummaryTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/13/21.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    static let identifier = "SummaryTableViewCell"
    @IBOutlet weak var summaryLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "SummaryTableViewCell", bundle: nil)
    }
    
    public func configure(text: String) {
        summaryLabel.text = text
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
