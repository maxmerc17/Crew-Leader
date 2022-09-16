//
//  EnterSpeciesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct EnterSpeciesView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var planter : Person
    @State var species : Species
    @Binding var block : Block
    @Binding var partials : [Partial]
    @State var totalTreesPlanted : Int = 0
    
    var releventPartials : [Partial] {
        get {
            partials.filter({ ($0.block == block) && ($0.species == species) && ($0.people[planter] != nil) })
        }
    }
    
    @State var numBoxes : String = ""
    
    func updateProduction() {
        numBoxes = String(newTallyData.blocks[block]?.individualTallies[planter]?.boxesPerSpecies[species] ?? 0)
        
        let treesFromBoxes = (Int(numBoxes) ?? 0)*species.treesPerBox
        let treesFromPartials = releventPartials.reduce(0, { x, y in
            x + (y.people[planter] ?? 0)*species.treesPerBundle
        })
        
        totalTreesPlanted = treesFromBoxes + treesFromPartials
        
        newTallyData.blocks[block]?.individualTallies[planter]?.treesPerSpecies[species] = totalTreesPlanted
    }
    //$newTallyData.blocks[block].individualTallies[planter]?.boxesPerSpecies[species]
    
    var body: some View {
        Section("\(species.name) - \(totalTreesPlanted) trees planted"){
            TextField("Boxes", text: $numBoxes)
                .keyboardType(.numberPad)
                .onChange(of: numBoxes){
                    newTallyData.blocks[block]?.individualTallies[planter]?.boxesPerSpecies[species] = Int($0)
                    updateProduction()
                }
            Section("Partials"){
                ForEach(releventPartials) { partial in
                    PartialCardView(partial: partial)
                }.onChange(of: releventPartials){
                    print($0)
                    updateProduction()
                }
            }
        }.onChange(of: planter){
            print($0)
            updateProduction()
        }
        .onChange(of: block){
            print($0)
            updateProduction()
        }.onAppear(){
            updateProduction()
        }
    }
}

struct EnterSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            EnterSpeciesView(
                newTallyData: .constant(DailyTally.Data()),
                planter: .constant(Person.sampleData[0]),
                species: Species.sampleData[0],
                block: .constant(Block.sampleData[0]),
                partials: .constant(Partial.sampleData)
            )
        }
    }
}
