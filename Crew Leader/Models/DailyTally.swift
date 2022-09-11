//
//  DailyPlanterTally.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import Foundation

struct DailyTally : Identifiable {
    var id : UUID
    var date : Date
    var contract : String
    var supervisor : Person
    var crew : Crew
    var commission : Double
    var blocks : [Block : DailyBlockTally]
    
    var treesPlanted : Int {
        return blocks.reduce(0){ partialResult, block in
            partialResult + block.value.treesPlanted
        }
    }
    
    init(id: UUID, date: Date, contract: String, supervisor: Person, crew: Crew, commission: Double, blocks: [Block : DailyBlockTally]) {
        self.id = id
        self.date = date
        self.contract = contract
        self.supervisor = supervisor
        self.crew = crew
        self.commission = commission
        self.blocks = blocks
    }
}

extension DailyTally {
    static let sampleData: [DailyTally] =
    [
        DailyTally(id: UUID(),
                   date: Date.now,
                   contract: "Canfor",
                   supervisor: Person.sampleSupervisor,
                   crew: Crew.sampleData,
                   commission: 0.15,
                   blocks: [Block.sampleData[0] : DailyBlockTally.sampleData[0], Block.sampleData[1] : DailyBlockTally.sampleData[1]]),
        
        DailyTally(id: UUID(),
                   date: Date.now,
                   contract: "Canfor",
                   supervisor: Person.sampleSupervisor,
                   crew: Crew.sampleData,
                   commission: 0.15,
                   blocks: [Block.sampleData[0] : DailyBlockTally.sampleData[0], Block.sampleData[1] : DailyBlockTally.sampleData[1]])
    ]
}

struct DailyBlockTally : Identifiable {
    var id : UUID
    var species : [Species]
    var individualTallies : [DailyPlanterTally]
    var treesPlanted : Int {
        return individualTallies.reduce(0) { partialResult, tally in
            partialResult + tally.treesPlanted
        }
    }
    var treesPlantedPerSpecies : [Species : Int] {
        var dict : [Species : Int] = [:]
        for species in species {
            dict[species] = individualTallies.reduce(0) { partialResult, tally in
                partialResult + (tally.treesPerSpecies[species] ?? 0)
            }
        }
        return dict
    }
    
    init(id: UUID, species: [Species], individualTallies: [DailyPlanterTally]) {
        self.id = id
        self.species = species
        self.individualTallies = individualTallies
    }
}

extension DailyBlockTally {
    static let sampleData = [ DailyBlockTally(id: UUID(), species: Array(Species.sampleData[0...3]), individualTallies: DailyPlanterTally.sampleData), DailyBlockTally(id: UUID(), species: Array(Species.sampleData[0...3]), individualTallies: DailyPlanterTally.sampleData) ]
}

struct DailyPlanterTally : Identifiable {
    var id : UUID
    var planter : Person
    var treesPerSpecies : [Species : Int] // is a dictionary
    var treesPlanted : Int {
        return treesPerSpecies.reduce(0) { partialResult, species in
            partialResult + species.value
        } // sums per species
    }
    
    init(id: UUID, planter: Person, treesPerSpecies: [Species : Int]) {
        self.id = id
        self.planter = planter
        self.treesPerSpecies = treesPerSpecies
    }
}

extension DailyPlanterTally {
    static let sampleData : [DailyPlanterTally] = [
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[0], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300]),
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[1], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300]),
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[2], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300]),
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[3], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300]),
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[4], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300]),
        DailyPlanterTally(id: UUID(), planter: Person.sampleData[5], treesPerSpecies: [Species.sampleData[0] : 500, Species.sampleData[1] : 300, Species.sampleData[2] : 600, Species.sampleData[3]: 300])
    ]
}








