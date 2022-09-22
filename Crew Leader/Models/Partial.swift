//
//  Partial.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import Foundation

struct Partial : Identifiable, Equatable {
    var id : UUID
    var blockName : String
    var species : Species
    var people : [Person : Int]
    
    var totalBundlesClaimed : Int {
        people.reduce(0){ tot, elem in tot + elem.value }
    }
    
    init(id: UUID = UUID(), blockName: String, species: Species, people: [Person : Int]) {
        self.id = id
        self.blockName = blockName
        self.species = species
        self.people = people
    }
}


extension Partial {
    struct Data {
        var blockName = ""
        var species = Species(data: Species.Data())
        var people : [Person : Int] = [:]
    }
    
    init(data: Data){
        id = UUID()
        blockName = data.blockName
        species = data.species
        people = data.people
    }
    
    mutating func update(data: Data){
        blockName = data.blockName
        species = data.species
        people = data.people
    }
}


extension Partial {
    static let sampleData = [
        Partial( blockName: Block.sampleData[0].blockNumber,
                 species: Species.sampleData[0],
                 people: [Person.sampleData[0] : 5, Person.sampleData[1] : 5, Person.sampleData[2] : 5, ])
    ]
}
