//
//  Species.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import Foundation

struct Species : Hashable {
    var name : String
    var numTrees : Int
    var treesPerBundle : Int
    var numBundles : Int {
        return self.numTrees / self.treesPerBundle
    }
    
    init(name: String, numTrees: Int, treesPerBundle: Int) {
        self.name = name
        self.numTrees = numTrees
        self.treesPerBundle = treesPerBundle
    }
}

extension Species {
    static let sampleData : [Species] = [
        Species(name: "Pli048", numTrees: 420, treesPerBundle: 20),
        Species(name: "Pli058", numTrees: 420, treesPerBundle: 20),
        Species(name: "Pli057", numTrees: 420, treesPerBundle: 20),
        Species(name: "Sx051", numTrees: 270, treesPerBundle: 15),
        Species(name: "SX072", numTrees: 400, treesPerBundle: 20)
    ]
}

/*
enum Species {
    case Pli048
    case Sx051
    
    var numTrees : Int {
        switch self {
            case .Pli048:
                return 420
            case .Sx051:
                return 270
        }
    }
    
    var numBundles : Int {
        switch self {
            case .Pli048:
                return 21
            case .Sx051:
                return 18
        }
    }
    
    var treesPerBundle : Int {
        return self.numTrees / self.numBundles
    }
}
*/
