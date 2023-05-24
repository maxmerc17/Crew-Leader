//
//  PointArray.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-07.
//

import Foundation

struct PointArray<Val: Conforming> {
    var points : [Point<Val>]
    var count : Int {
        points.count
    }
    
    var maxPoint : Point<Val>? {
        guard !points.isEmpty else { return nil }
        
        return points.max(by: { a, b in a.dubY < b.dubY } )
    }
    var minPoint : Point<Val>? {
        guard !points.isEmpty else { return nil }
        
        return points.min(by: { a, b in a.dubY < b.dubY })
    }
    var yAxisMax : Double? {
        guard !points.isEmpty else { return nil }
        
        if let mp = maxPoint {
            let order = floor(log10(mp.dubY)) // ex 100 -> order 2, 6 -> order 0, 9 -> order 0
            
            let n = 1*pow(10, order) // ex n = 100 , n = 1, n = 1
            let n_1 = (order == 0) ? 0 : pow(10, order - 1) // ex n_1 = 10 , n_1 = 0, n_1 = 0
            
            let placeValues = ( order <= 1 ? [0] : [1, 2, 5, 8] )
            
            for j in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] {
                let dj = Double(j)
                for i in placeValues {
                    let di = Double(i)
                    let maxVal = ( dj * n ) + ( di * n_1 ) // ex maxVal = 100
                    
                    if Int(maxVal) % 4 == 0 && mp.dubY <= maxVal { /// maxVal will always be Integer
                        return maxVal // ex 100
                    }
                }
            }
            return pow(10, order + 1)
        }
        return nil
    }
    
    var numVisable = 10
    
    init() {
        self.points = []
    }
    
    mutating func update(xyData: [(x: String, y: Val)]){
        let points = xyData.map { x, y in Point<Val>(x: x, y: y) }
        self.points = points
    }
    mutating func setPosition(w: W) {
        guard !points.isEmpty else {
            return
        }
        
        let start = w.O.x + w.W*0.05
        let end = w.O.x + w.W*0.95
        let buffer = (end - start) / CGFloat(min(points.count-1, numVisable))
        
        let scale = w.H / CGFloat(yAxisMax!)
        
        for i in 0..<points.count {
            points[i].posX = start + ( CGFloat(i % numVisable) * buffer )
            points[i].posY = w.O.y - ( points[i].dubY * scale )
            points[i].visable = i < numVisable ? true : false
        }
    }
    
    func ScaleVals() -> [String] { /// returns values for scale that will be displayed. If yAxisMax is nil it returns ["3", "6", ... ]
        if let yam = yAxisMax {
            let order = floor(log10(yam))
            if order < 6 {
                return [ (yam*0.25).displayFormatted,
                         (yam*0.5).displayFormatted,
                         (yam*0.75).displayFormatted,
                         (yam).displayFormatted ]
            } else {
                return [ (yam*0.25).scientificFormatted, (yam*0.5).scientificFormatted, (yam*0.75).scientificFormatted, (yam).scientificFormatted ]
            }
        }
        return ["3", "6", "9", "12"]
    }
    func ScaleWidth() -> CGFloat {
        if let yam = yAxisMax {
           let order = floor(log10(yam))
           
            switch order {
                case 0...3 :
                    return 40
                case 4...10 :
                    return 50
                default :
                    return 70
            }
        }
        return 40
    }
    
    // MARK: Visability
    var numSets : Int {
        Int(ceil(Double(points.count) / Double(numVisable)))
    }
    
    var _visableSet : Int = 1
    var visableSet : Int {
        get {
            return _visableSet
        }
        set {
            guard newValue <= numSets && 0 < newValue else {
                return
            }
            _visableSet = newValue
            for i in 0..<points.count {
                points[i].visable = (newValue-1)*numVisable < i+1 && i+1 <= newValue*numVisable
            }
        }
    }
    mutating func increment() {
        visableSet += 1
    }
    mutating func decrement() {
        visableSet -= 1
    }
    
}
