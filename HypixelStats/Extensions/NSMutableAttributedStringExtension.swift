//
//  NSMutableAttributedStringExtension.swift
//  HypixelStats
//
//  Created by Edison Ooi on 8/30/21.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    func setColor(color: UIColor, stringValue: String = "") {
        var range: NSRange = self.mutableString.range(of: self.string, options: .caseInsensitive)
        
        if stringValue != "" {
            range = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        }
        
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
