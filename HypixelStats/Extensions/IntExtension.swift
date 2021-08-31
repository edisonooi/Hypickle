//
//  IntExtension.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/17/21.
//

import Foundation

extension Int {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    internal var withCommas: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension UInt64 {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    internal var withCommas: String {
        return UInt64.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
