//
//  GenericHeaderView.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/22/21.
//

import UIKit

class GenericHeaderView: UIView {
    @IBOutlet weak var title: UILabel!
    
    class func instanceFromNib() -> GenericHeaderView {
        return UINib(nibName: "GenericHeaderView", bundle: Bundle(for: GenericHeaderView.self)).instantiate(withOwner: nil, options: nil)[0] as! GenericHeaderView
    }
    
}
