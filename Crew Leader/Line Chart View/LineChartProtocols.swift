//
//  LineChartProtocols.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-07.
//

import Foundation

protocol Conforming{
    func toString() -> String
    
}
extension Int: Conforming {
    func toString() -> String {
        String(self)
    }
}
extension Float: Conforming {
    func toString() -> String {
        String(self)
    }
}
extension Double: Conforming {
    static func convert(_ number: Conforming) -> Double {
        if let intNum = number as? Int {
            return Double(intNum)
        } else if let floatNum = number as? Float {
            return Double(floatNum)
        } else if let doubleNum = number as? Double {
            return Double(doubleNum)
        } else {
            return 0.0
        }
    }
    func toString() -> String {
        String(self)
    }
}
