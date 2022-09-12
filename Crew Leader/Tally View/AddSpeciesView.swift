//
//  AddSpeciesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

//TODO: make picker default an item in the list that can be added right away

import SwiftUI

struct AddSpeciesView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var selectedBlock : Block
    
    @State var selectedSpecies : Species = Species(data: Species.Data())
    @State var speciesList : [Species] = []//Species.sampleData
    
    func newSpeciesClicked(){
        //speciesList.append(selectedSpecies)
        newTallyData.blocks[selectedBlock]?.species.append(selectedSpecies)
    }
    
    var body: some View {
        Form{
            Section("Species"){
                ForEach(newTallyData.blocks[selectedBlock]?.species ?? []) { species in
                    Label("\(species.name)", systemImage: "leaf")
                }
                HStack{
                    Picker("Add Species", selection: $selectedSpecies){
                        ForEach(Species.sampleData) {
                            species in Text(species.name).tag(species)
                        }
                    }
                    Spacer()
                    
                }
                HStack{
                    Spacer()
                    Button(action : newSpeciesClicked){
                        Text("Add")
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesView(newTallyData: .constant(DailyTally.Data()),
                       selectedBlock: .constant(Block(data: Block.Data())))
    }
}
