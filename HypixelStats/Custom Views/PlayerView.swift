//
//  PlayerView.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/30/21.
//

import UIKit

class PlayerView: UIView {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var skinImageView: UIImageView!
    
    class func instanceFromNib() -> PlayerView {
        return UINib(nibName: "PlayerView", bundle: Bundle(for: PlayerView.self)).instantiate(withOwner: nil, options: nil)[0] as! PlayerView
    }
    
}
