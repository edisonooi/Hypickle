//
//  MinigameHeaderView.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/23/21.
//

import Foundation
import UIKit

class MinigameHeaderView: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    class func instanceFromNib() -> MinigameHeaderView {
        return UINib(nibName: "MinigameHeaderView", bundle: Bundle(for: MinigameHeaderView.self)).instantiate(withOwner: nil, options: nil)[0] as! MinigameHeaderView
    }
    
}
