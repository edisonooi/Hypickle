//
//  GamesTableViewCell.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/16/21.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    static let identifier = "GamesTableViewCell"
    

    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "GamesTableViewCell", bundle: nil)
    }
    
    public func configure(imageName: String, title: String) {
        gameTitle.text = title
        gameIcon.image = UIImage(named: imageName)
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
