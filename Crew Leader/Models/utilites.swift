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
}
