//
//  Partial.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import Foundation

struct Partial : Identifiable, Equatable {
    var id : UUID
    var block : Block
    var species : Species
    var people : [Person : Int]
    
    init(id: UUID = UUID(), block: Block, species: Species, people: [Person : Int]) {
        self.id = id
        self.block = block
        self.species = species
        self.people = people
    }
}

extension Partial {
    struct Data {
        var block = Block(data: Block.Data())
        var species = Species(data: Species.Data())
        var people : [Person : Int] = [:]
    }
    
    init(data: Data){
        id = UUID()
        block = data.block
        species = data.species
        people = data.people
    }
    
    mutating func update(data: Data){
        block = data.block
        species = data.species
        people = data.people
    }
}


extension Partial {
    static let sampleData = [
        Partial( block: Block.sampleData[0],
                 species: Species.sampleData[0],
                 people: [Person.sampleData[0] : 5, Person.sampleData[1] : 5, Person.sampleData[2] : 5, ])
    ]
}
