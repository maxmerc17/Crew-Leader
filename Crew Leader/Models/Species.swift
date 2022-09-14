//
//  Species.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import Foundation

struct Species : Hashable, Identifiable, Comparable {
    var id : UUID
    var name : String
    var numTrees : Int
    var treesPerBundle : Int
    var numBundles : Int {
        return self.numTrees / self.treesPerBundle
    }
    
    init(id: UUID = UUID(), name: String, numTrees: Int, treesPerBundle: Int) {
        self.id = id
        self.name = name
        self.numTrees = numTrees
        self.treesPerBundle = treesPerBundle
    }
    
    static func < (lhs: Species, rhs: Species) -> Bool {
        if lhs.name < rhs.name{
            return true
        }else{ return false }
    }
}


extension Species {
    struct Data {
        var name = ""
        var numTrees = 0
        var treesPerBundle = 0
    }
    
    init(data: Data){
        id = UUID()
        name = data.name
        numTrees = data.numTrees
        treesPerBundle = data.treesPerBundle
    }
    
    mutating func update(data: Data){
        name = data.name
        numTrees = data.numTrees
        treesPerBundle = data.treesPerBundle
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
