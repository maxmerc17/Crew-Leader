//
//  Point.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-07.
//

import Foundation

struct Point<T: Conforming>: Identifiable {
    
    var id: UUID = UUID()
    var x: String
    var y: T
    var dubY: Double {
        Double.convert(y)
    }
    
    var posX : CGFloat = 0
    var posY : CGFloat = 0
    var visable : Bool = false
    
    var position : CGPoint {
        CGPoint(x: posX, y: posY)
    }
}
