//
//  BlockSwitchView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

// TODO: add a transition where the block data slides in when different blocks are selected
// TODO: add alert when species won't add because it is already in the list

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct AddSpeciesView: View {
    @Binding var newTallyData : DailyTally
    @State var selectedBlock : String
    
    var blocks : [String] {
        get{
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var blockObjects : [Block]{
        blocks.map({ blockString in blockStore.getBlock(blockName: blockString)! }) /// !!
    }
    
    @State var showAlert : Bool = false
    
    @EnvironmentObject var blockStore : BlockStore
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                ForEach(blockObjects) { block in
                    Button {
                        selectedBlock = block.blockNumber
                    } label: {
                        
                        HStack {
                            Image(systemName: "map")
                            Text("\(block.blockNumber)")}.font(.system(size: 15))
                            .foregroundColor(block.blockNumber == selectedBlock
                                ? .accentColor
                                         : .gray)
                    }
                }
            }.padding().background(.white).cornerRadius(10)
            
            if selectedBlock != ""{
                AddSpeciesSubView(newTallyData: $newTallyData, selectedBlock: $selectedBlock, showAlert: $showAlert).transition(.move(edge: .trailing))
            }
            
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Cannot Add Selected Species To List"),
                message: Text("The selected species is already in the list.")
            )
        }
    }
}

struct AddSpeciesSubView: View {
    @Binding var newTallyData : DailyTally
    @Binding var selectedBlock : String
    @Binding var showAlert : Bool
    
    @State var selectedSpecies : Species = Species.init(data: Species.Data()) /// updatedOnAppear , FOD
    
    
    @EnvironmentObject var speciesStore : SpeciesStore
    
    var speciesList : [Species] {
        get {
            return newTallyData.getSpeciesList(block: selectedBlock)! // !!
        }
    }
    
    func newSpeciesClicked(){
        if !speciesList.contains(selectedSpecies) {
            newTallyData.addSpecies(block: selectedBlock, add: selectedSpecies)
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
                        ForEach(speciesStore.species) {
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
        }
        .scrollContentBackground(.hidden)
        .onAppear(){
            selectedSpecies = speciesStore.species[0] /// FOD
        }
        
            
    }
}

struct AddSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesView(newTallyData: .constant(DailyTally.sampleData[0]),
                            selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0]
        
        )
    }
}

struct AddSpeciesSubView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesSubView(newTallyData: .constant(DailyTally.sampleData[0]),
                          selectedBlock: .constant(Block(data: Block.Data()).blockNumber), showAlert: .constant(false)).environmentObject(BlockStore())
    }
}
