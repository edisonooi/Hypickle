//
//  GameTypes.swift
//  HypixelStats
//
//  Created by codeplus on 7/19/21.
//

import Foundation

class Utils {
    
    struct game {
        var typeName: String
        var databaseName: String
        var cleanName: String
    }
    
    static func calculateRatio(numerator: Int, denominator: Int) -> String {
        
        let kills2 = Double(numerator)
        let deaths2 = denominator < 0 ? 0.0 : Double(denominator)
        var kdr = 0.0
        
        if kills2 == 0.0 && deaths2 == 0.0 {
            kdr = 0.0
        } else if kills2 != 0.0 && deaths2 == 0.0 {
            kdr = kills2
        } else {
            kdr = kills2 / deaths2
        }
        
        return String(format: "%.2f", kdr)
    }
    
    static func calculatePercentage(numerator: Int, denominator: Int) -> String {
        
        let kills2 = Double(numerator)
        let deaths2 = denominator < 0 ? 0.0 : Double(denominator)
        var kdr = 0.0
        
        if kills2 == 0.0 && deaths2 == 0.0 {
            kdr = 0.0
        } else if kills2 != 0.0 && deaths2 == 0.0 {
            kdr = kills2
        } else {
            kdr = kills2 / deaths2
        }
        
        return String(format: "%.2f%%", kdr * 100)
    }
    
    
    
    static func convertToRomanNumerals(number: Int) -> String {
        let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

        var romanValue = ""
        var startingValue = number
        
        for (index, romanChar) in romanValues.enumerated() {
            let arabicValue = arabicValues[index]

            let div = startingValue / arabicValue
        
            if (div > 0)
            {
                for _ in 0..<div
                {
                    //println("Should add \(romanChar) to string")
                    romanValue += romanChar
                }

                startingValue -= arabicValue * div
            }
        }
        
        return romanValue
    }
    
    static func formatMinuteSeconds(totalSeconds: Int) -> String {
        let min = Int(totalSeconds / 60)
        let sec = Int(Double(totalSeconds).truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    static func convertToHoursMinutesSeconds(seconds: Int) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    static func convertToDateStringFormat(milliseconds: UInt64) -> String {
        let secondsSince1970 = milliseconds / 1000
        
        let date = Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    static func convertToDate(milliseconds: UInt64) -> Date {
        let secondsSince1970 = milliseconds / 1000
        
        return Date(timeIntervalSince1970: TimeInterval(secondsSince1970))
    }
}
