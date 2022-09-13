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
    @State var selectedBlock : Block

    var blocks : [Block] {
        get{
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                ForEach(blocks) { block in
                    Button {
                        selectedBlock = block
                    } label: {
                        Text("\(block.blockNumber)")
                            .font(.system(size: 15))
                            .foregroundColor(block == selectedBlock
                                ? .accentColor
                                : .gray)
                            .animation(nil)
                    }
                }
            }.padding()
            
            if selectedBlock.blockNumber != ""{
                AddSpeciesSubView(newTallyData: $newTallyData, selectedBlock: $selectedBlock).transition(.move(edge: .trailing))
            }
            
        }
    }
}

struct AddSpeciesSubView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var selectedBlock : Block
    
    @State var selectedSpecies : Species = Species.sampleData[0]
    
    func newSpeciesClicked(){
        if selectedSpecies.name != "" {
            newTallyData.blocks[selectedBlock]?.species.append(selectedSpecies)
        }
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
                            selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0]
        
        )
    }
}

struct AddSpeciesSubView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesSubView(newTallyData: .constant(DailyTally.Data()),
                       selectedBlock: .constant(Block(data: Block.Data())))
    }
}
