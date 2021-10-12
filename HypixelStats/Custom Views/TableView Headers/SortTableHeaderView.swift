//
//  SortTableHeaderView.swift
//  HypixelStats
//
//  Created by Edison Ooi on 10/11/21.
//

import UIKit

class SortTableHeaderView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortButtonHeight: NSLayoutConstraint!
    
    
    class func instanceFromNib() -> SortTableHeaderView {
        return UINib(nibName: "SortTableHeaderView", bundle: Bundle(for: SortTableHeaderView.self)).instantiate(withOwner: nil, options: nil)[0] as! SortTableHeaderView
    }

}
