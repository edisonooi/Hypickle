//
//  CoinsView.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/17/21.
//

import UIKit

class CoinsView: UIView {

    @IBOutlet weak var coinsIcon: UIImageView!
    @IBOutlet weak var coinAmount: UILabel!
    
    class func instanceFromNib() -> CoinsView {
        return UINib(nibName: "CoinsView", bundle: Bundle(for: CoinsView.self)).instantiate(withOwner: nil, options: nil)[0] as! CoinsView
    }

}
