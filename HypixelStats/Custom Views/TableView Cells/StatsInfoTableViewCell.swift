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
    
    public func configureDefault(statsTableData: [CellData], indexPath: IndexPath) {
        var category = ""
        var value: Any = ""
        
        if indexPath.row == 0 {
            if !statsTableData[indexPath.section].sectionData.isEmpty {
                self.showDropDown()
            }
            
            category = statsTableData[indexPath.section].headerData.0
            value = statsTableData[indexPath.section].headerData.1
            
            if statsTableData[indexPath.section].color != .label {
                self.statValue.textColor = statsTableData[indexPath.section].color
            }
            
        } else {
            category = statsTableData[indexPath.section].sectionData[indexPath.row - 1].0
            value = statsTableData[indexPath.section].sectionData[indexPath.row - 1].1
            
            self.statCategory.textColor = UIColor(named: "gray_label")
            self.statCategory.font = UIFont.systemFont(ofSize: 14)
            self.statValue.textColor = UIColor(named: "gray_label")
            self.statValue.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        if value is Int {
            value = (value as! Int).withCommas
        }
        
        self.configure(category: category, value: "\(value)")
    }
    
    override func prepareForReuse() {
        self.statCategory.textColor = .label
        self.statCategory.font = UIFont.systemFont(ofSize: 17)
        self.statValue.textColor = .label
        self.statValue.font = UIFont.boldSystemFont(ofSize: 17)
        self.dropDownIconWidth.constant = 0.0
        self.backgroundColor = .tertiarySystemBackground
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
