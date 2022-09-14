//
//  CacheCalculator.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import Foundation

struct CacheCalculator {
    var numTrees : Int
    var cuts : [Cut]
    
    var totalBoxes : Int {
        return calculateBoxesPerSpecies().reduce(0, { tot, val in tot + val.1 })
    }
    
    var totalTrees : Int {
        return calculateBoxesPerSpecies().reduce(0, { tot, val in tot + (val.0.numTrees * val.1) })
    }
    
    init(numTrees: Int, cuts: [Cut]) {
        self.numTrees = numTrees
        self.cuts = cuts
    }
    
    init(numTrees: Int, cuts: [(Species, Int)]){
        self.numTrees = numTrees
        
        var newCuts : [Cut] = []
        for i in cuts {
            var newCut = Cut(tuple: i)
            newCuts.append(newCut)
        }
        
        self.cuts = newCuts
    }
    
    func calculateBoxesPerSpecies() -> [(Species, Int)] {
        var speciesAndBoxesArray : [(Species, Int)] = []
        for cut in cuts {
            speciesAndBoxesArray.append((cut.species, cut.numBoxes(numTrees)))
        }
        return speciesAndBoxesArray
    }
    
}

struct Cut : Identifiable {
    var id: UUID
    var species : Species
    @Percent var percent : Int
    
    var tuple : (Species, Int) {
        get {
            return (species, percent)
        }
    }
    
    init(id: UUID = UUID(), species: Species, percent: Int) {
        self.id = id
        self.species = species
        self.percent = percent
    }
    
    init(tuple: (Species, Int)){
        self.id = UUID()
        self.species = tuple.0
        self.percent = tuple.1
    }
    
    /// returns least number of boxes  to supply the desired number of trees
    func numBoxes(_ totalTrees: Int) -> Int{
        let numTrees : Int = Int(Float(totalTrees) * Float(percent / 100))
        let treesPerBox = species.numTrees
        let totalBoxes = numTrees / treesPerBox
        
        if (totalBoxes * treesPerBox < numTrees) {
            return totalBoxes+1
        }
        else {
            return totalBoxes
        }
    }
}

extension CacheCalculator {
    static let sampleData = [CacheCalculator(numTrees: 15000, cuts: Cut.sampleData)]
}

extension Cut {
    static let sampleData = [Cut(species: Species.sampleData[0], percent: 50), Cut(species: Species.sampleData[1], percent: 50)]
}


@propertyWrapper
struct Percent {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = max(0, min(newValue, 100)) }
    }
}
