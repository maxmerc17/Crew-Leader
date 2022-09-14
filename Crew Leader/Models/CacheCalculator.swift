//
//  CacheCalculator.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import Foundation

struct CacheCalculator : Identifiable {
    var id : UUID
    var desiredTrees : Int
    var cuts : [Cut]
    
    var totalBoxes : Int {
        return calculateBoxesPerSpecies().reduce(0, { tot, val in tot + val.1 })
    }
    
    var totalTrees : Int {
        return calculateBoxesPerSpecies().reduce(0, { tot, val in tot + (val.0.numTrees * val.1) })
    }
    
    var totalPercentage : Int {
        return cuts.reduce(0, { x, y in x + y.percent})
    }
    
    init(id: UUID = UUID(), desiredTrees: Int, cuts: [Cut]) {
        self.id = id
        self.desiredTrees = desiredTrees
        self.cuts = cuts
    }
    
    init(id: UUID = UUID(), desiredTrees: Int, cuts: [(Species, Int)]){
        self.id = id
        self.desiredTrees = desiredTrees
        
        var newCuts : [Cut] = []
        for i in cuts {
            let newCut = Cut(tuple: i)
            newCuts.append(newCut)
        }
        
        self.cuts = newCuts
    }
    
    init(id: UUID = UUID(), desiredTrees: Int, cuts: [(Species, String)]){
        self.id = UUID()
        self.desiredTrees = desiredTrees
        
        var newCuts : [Cut] = []
        for cut in cuts {
            let species = cut.0
            let percent = Int(cut.1)!
            let newCut = Cut(species: species, percent: percent)
            newCuts.append(newCut)
        }
        
        self.cuts = newCuts
    }
    
    func calculateBoxesPerSpecies() -> [(Species, Int)] {
        var speciesAndBoxesArray : [(Species, Int)] = []
        for cut in cuts {
            speciesAndBoxesArray.append((cut.species, cut.numBoxes(desiredTrees)))
        }
        return speciesAndBoxesArray
    }
    
    func calculateActualPercent(cut: Cut) -> String{
        var formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        if let item = cuts.first(where: {$0 == cut}){
            let treesCalculated = item.numTrees(desiredTrees)
            let floatResult = (Float(treesCalculated) / Float(totalTrees)) * 100
            return formatter.string(for: floatResult)!//Double(String(floatResult).prefix(4))!
        } else {
            return "0"
        }
    }
    
}

struct Cut : Identifiable, Equatable {
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
        let percentage = Float(percent) / 100
        let numTrees : Int = Int(Float(totalTrees) * percentage)
        let treesPerBox = species.numTrees
        let totalBoxes = numTrees / treesPerBox
        
        if (totalBoxes * treesPerBox < numTrees) {
            return totalBoxes+1
        }
        else {
            return totalBoxes
        }
    }
    
    func numTrees(_ totalTrees: Int) -> Int {
        return numBoxes(totalTrees)*species.numTrees
    }
    
    static func == (lhs: Cut, rhs: Cut) -> Bool {
        return lhs.species == rhs.species && lhs.percent == rhs.percent
    }
}

extension CacheCalculator {
    struct Data {
        var desiredTrees : Int = 0
        var cuts : [Cut] = []
    }
    
    init(data: Data){
        id = UUID()
        desiredTrees = data.desiredTrees
        cuts = data.cuts
    }
}

extension Cut {
    struct Data {
        var species : Species = Species(data: Species.Data())
        var percent : Int = 0
    }
    
    init(data: Data){
        id = UUID()
        species = data.species
        percent = data.percent
    }
}

extension CacheCalculator {
    static let sampleData = [CacheCalculator(desiredTrees: 15000, cuts: Cut.sampleData)]
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
