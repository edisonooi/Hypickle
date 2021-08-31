//
//  DoubleExtension.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/31/21.
//

import Foundation

extension Double {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    internal var withCommas: String {
        return Double.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
