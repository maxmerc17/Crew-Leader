//
//  NewTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

//TODO: make picker default an item in the list that can be added right away
// TODO: add checking so someone can't add a block to the list twice
// TODO: add create new block button - create a block if it doesn't yet exist

struct NewTallyView: View {
    @Binding var newTallyData : DailyTally.Data
    
    @State var selectedBlock : Block = Block(data: Block.Data()) // for picker
    
    @State var blocksList : [Block] = [] // list of blocks for tally
    
    func newBlockClicked(){
        if selectedBlock.blockNumber != "" {
            blocksList.append(selectedBlock)
            newTallyData.blocks[selectedBlock] = DailyBlockTally(data: DailyBlockTally.Data())
        }
        // else have pop up saying to select a block
    }
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section("Block Information"){
                    HStack{
                        Label("Date", systemImage: "calendar")
                        Spacer()
                        DatePicker(selection: $newTallyData.date, displayedComponents: .date, label: { Text("")})
                    }
                }
                Section("Blocks"){
                    ForEach(blocksList) { block in
                        Label("\(block.blockNumber)", systemImage: "map")
                    }
                    
                    HStack {
                        Picker("Add Block", selection: $selectedBlock){
                            ForEach(Block.sampleData) { block in
                                Text(block.blockNumber).tag(block)
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action : newBlockClicked){
                            Text("Add")
                        }
                        Spacer()
                    }
                }
            }
            VStack{
                Divider()
                AddSpeciesContainer(newTallyData: $newTallyData, blocks: $blocksList)
                NavigationLink(destination: EnterTallyView(newTallyData: $newTallyData)){
                    Text("Crew Tallies")
                } // TODO: verify that the correct amout of information has been inputted to enter crew tallies (leave button disabled until required info is inputted)
            }
            
        }
        
    }
}

struct NewTallyView_Previews: PreviewProvider {
    static var previews: some View {
        NewTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
