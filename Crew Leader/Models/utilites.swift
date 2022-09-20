//
//  utilites.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import Foundation

struct utilities {
    static func formatDate(date : Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"
        return dateFormatterPrint.string(from: date)
    }
    
    static func formatFloat(float: Float) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter.string(for: float)!
    }
    
    static func formatInteger(_ integer: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:integer))!
    }
}
