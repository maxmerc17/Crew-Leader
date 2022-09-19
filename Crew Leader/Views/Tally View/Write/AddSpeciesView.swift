//
//  BlockSwitchView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

// TODO: have the first block on the list automatically selected - displaying it's content
// TODO: add a transition where the block data slides in when different blocks are selected

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct AddSpeciesView: View {
    @Binding var newTallyData : DailyTally.Data
    @State var selectedBlock : String

    var blocks : [String] {
        get{
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var blockObjects : [Block]{
        blocks.map({ blockString in Block.sampleData.first(where: { $0.blockNumber == blockString })! })
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                ForEach(blockObjects) { block in
                    Button {
                        selectedBlock = block.blockNumber
                    } label: {
                        
                        HStack {
                            Image(systemName: "map")
                            Text("\(block.blockNumber)")                        }.font(.system(size: 15))
                            .foregroundColor(block.blockNumber == selectedBlock
                                ? .accentColor
                                         : .gray)
                    }
                }
            }.padding().background(.white).cornerRadius(10)
            
            if selectedBlock != ""{
                AddSpeciesSubView(newTallyData: $newTallyData, selectedBlock: $selectedBlock).transition(.move(edge: .trailing))
            }
            
        }
    }
}

struct AddSpeciesSubView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var selectedBlock : String
    
    @State var selectedSpecies : Species = Species.sampleData[0]
    @State var showAlert = false
    
    var speciesList : [Species] {
        get {
            return newTallyData.blocks[selectedBlock]?.species ?? []
        }
    }
    
    func newSpeciesClicked(){
        if !speciesList.contains(selectedSpecies) {
            newTallyData.blocks[selectedBlock]?.species.append(selectedSpecies)
        } else {
            showAlert = true
        }
    }
    
    var body: some View {
        Form{
            Section("Species"){
                ForEach(speciesList) { species in
                    Label("\(species.name)", systemImage: "leaf")
                }
                HStack{
                    Picker("Add Species", selection: $selectedSpecies){
                        ForEach(Species.sampleData) {
                            species in
                            HStack{
                                Text("\(species.name) ") +
                                Text("(\(species.treesPerBox) trees/box)").font(.caption)
                            }
                            .tag(species)
                        }
                    }
                    
                }
                HStack{
                    Spacer()
                    Button(action : newSpeciesClicked){
                        Text("Add")
                    }
                    Spacer()
                }
            }
        }.scrollContentBackground(.hidden)
            .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Cannot Add Selected Species To List"),
                        message: Text("The selected species is already in the list.")
                    )
                }
    }
}

struct AddSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesView(newTallyData: .constant(DailyTally.Data()),
                            selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0]
        
        )
    }
}

struct AddSpeciesSubView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesSubView(newTallyData: .constant(DailyTally.Data()),
                          selectedBlock: .constant(Block(data: Block.Data()).blockNumber))
    }
}
