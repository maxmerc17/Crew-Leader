//
//  EnterSpeciesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct EnterSpeciesView: View {
    @Binding var newTallyData : DailyTally.Data
    @State var planter : Person
    @State var species : Species
    @State var block : Block
    @Binding var partials : [Partial]
    
    @State var numBoxes : String = ""
    
    func updateProduction() {
        newTallyData.blocks[block]?.individualTallies[planter]?.treesPerSpecies[species] = (Int(numBoxes) ?? 0)*species.numTrees
    }
    
    var body: some View {
        Section("\(species.name)"){
            TextField("Boxes", text: $numBoxes)
                .keyboardType(.numberPad)
                .onChange(of: numBoxes){
                    print($0)
                    updateProduction()
                }
            Section("Partials"){
                ForEach(partials) { partial in
                    PartialCardView(partial: partial)
                }
            }
        }
    }
}

struct EnterSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            EnterSpeciesView(
                newTallyData: .constant(DailyTally.Data()),
                planter: Person.sampleData[0],
                species: Species.sampleData[0],
                block: Block.sampleData[0],
                partials: .constant(Partial.sampleData)
            )
        }
    }
}
