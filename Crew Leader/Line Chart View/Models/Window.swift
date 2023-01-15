//
//  Window.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-07.
//

import Foundation

struct W: Equatable {
     var W : CGFloat
     var H : CGFloat
     var O : CGPoint
     var SW : CGFloat
    
    init(W: CGFloat, H: CGFloat, O: CGPoint, SW: CGFloat) {
        self.W = W
        self.H = H
        self.O = O
        self.SW = SW
    }
    
    init(){
        self.W = 0
        self.H = 0
        self.O = CGPoint(x: 0, y: 0)
        self.SW = 0
    }
    
    mutating func update(W: CGFloat, H: CGFloat, O: CGPoint, SW: CGFloat){
        self.W = W
        self.H = H
        self.O = O
        self.SW = SW
    }
}
