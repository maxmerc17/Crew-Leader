//
//  EnterSpeciesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

// TODO: add a remove partial button
// TODO: add an edit partial button

import SwiftUI

struct EnterSpeciesView: View {
    @Binding var newTallyData : DailyTally
    @Binding var planter : Person
    @State var species : Species
    @Binding var block : String
    @Binding var partials : [Partial]
    @State var totalTreesPlanted : Int = 0
    
    var releventPartials : [Partial] {
        get {
            partials.filter({ ($0.blockName == block) && ($0.species == species) && ($0.people[planter] != nil) })
        }
    }
    
    @State var numBoxes : String = ""
    
    func updateProduction() {
        print(planter.id)
        numBoxes = String(newTallyData.blocks[block]?.individualTallies[planter.id]?.boxesPerSpecies[species] ?? 0)
        
        let treesFromBoxes = (Int(numBoxes) ?? 0)*species.treesPerBox
        let treesFromPartials = releventPartials.reduce(0, { x, y in
            x + (y.people[planter] ?? 0)*species.treesPerBundle
        })
        
        totalTreesPlanted = treesFromBoxes + treesFromPartials
        
        newTallyData.blocks[block]?.individualTallies[planter.id]?.treesPerSpecies[species] = totalTreesPlanted
    }
    //$newTallyData.blocks[block].individualTallies[planter]?.boxesPerSpecies[species]
    
    
    var body: some View {
        Section("\(species.name) - \(totalTreesPlanted) trees planted"){
            HStack {
                Label("Boxes", systemImage: "shippingbox")
                Text("(\(species.treesPerBox) trees / box)").font(.caption)
                Spacer()
                TextField("Boxes", text: $numBoxes).multilineTextAlignment(.trailing)
                    .onChange(of: numBoxes){
                        newTallyData.blocks[block]?.individualTallies[planter.id]?.boxesPerSpecies[species] = Int($0)
                        updateProduction()
                            
                }
            }
            if releventPartials.isEmpty {
                Text("No partials for \(species.name)").foregroundColor(.gray)
            }else {
                ForEach(releventPartials) { partial in
                    PartialCardView(partial: partial)
                }.onChange(of: releventPartials){
                    print($0)
                    updateProduction()
                }
            }
        }
        .onChange(of: planter){
            print($0)
            updateProduction()
        }
        .onChange(of: block){
            print($0)
            updateProduction()
        }
        .onAppear(){
            updateProduction()
        }
    }
}

struct EnterSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            EnterSpeciesView(
                newTallyData: .constant(DailyTally.sampleData[0]),
                planter: .constant(Person.sampleData[0]),
                species: Species.sampleData[0],
                block: .constant(Block.sampleData[0].blockNumber),
                partials: .constant(Partial.sampleData)
            )
        }
    }
}
