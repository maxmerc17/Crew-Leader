//
//  Partial.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import Foundation

struct Partial : Identifiable {
    var id : UUID
    var species : Species
    var people : [Person : Int]
    
    init(id: UUID = UUID(), species: Species, people: [Person : Int]) {
        self.id = id
        self.species = species
        self.people = people
    }
}

extension Partial {
    static let sampleData = [
        Partial(species: Species.sampleData[0],
                people: [Person.sampleData[0] : 5, Person.sampleData[1] : 5, Person.sampleData[2] : 5, ])
    ]
}
