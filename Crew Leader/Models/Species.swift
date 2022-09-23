//
//  Species.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import Foundation

struct Species : Hashable, Identifiable, Comparable, Equatable, Codable {
    var id : UUID
    var name : String
    var treesPerBox : Int
    var treesPerBundle : Int
    var numBundles : Int {
        return treesPerBox / treesPerBundle
    }
    
    init(id: UUID = UUID(), name: String, treesPerBox: Int, treesPerBundle: Int) {
        self.id = id
        self.name = name
        self.treesPerBox = treesPerBox
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
        var treesPerBox = 0
        var treesPerBundle = 0
    }
    
    init(data: Data){
        id = UUID()
        name = data.name
        treesPerBox = data.treesPerBox
        treesPerBundle = data.treesPerBundle
    }
    
    mutating func update(data: Data){
        name = data.name
        treesPerBox = data.treesPerBox
        treesPerBundle = data.treesPerBundle
    }
}

extension Species {
    static let sampleData : [Species] = [
        Species(name: "Pli048", treesPerBox: 420, treesPerBundle: 20),
        Species(name: "Pli058", treesPerBox: 420, treesPerBundle: 20),
        Species(name: "Pli057", treesPerBox: 420, treesPerBundle: 20),
        Species(name: "Sx051", treesPerBox: 270, treesPerBundle: 15),
        Species(name: "SX072", treesPerBox: 400, treesPerBundle: 20)
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
