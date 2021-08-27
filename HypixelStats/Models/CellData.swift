//
//  CellData.swift
//  HypixelStats
//
//  Created by codeplus on 7/22/21.
//

import Foundation
import UIKit

struct CellData {
    var headerData: (String, Any)
    var sectionData: [(String, Any)] = []
    var color: UIColor = .label
    var isOpened: Bool = false
    
}
