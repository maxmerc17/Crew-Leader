//
//  NewTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct NewTallyView: View {
    @Binding var newTallyData : DailyTally.Data
    
    @State var selectedBlock : Block = Block(data: Block.Data())
    @State var selectedDate : Date = Date.now
    
    @State var blocksList : [Block] = []
    
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
                        DatePicker(selection: $selectedDate, displayedComponents: .date, label: { Text("")})
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
            Divider()
            AddSpeciesContainer(newTallyData: $newTallyData, blocks: $blocksList)
        }
        
    }
}

struct NewTallyView_Previews: PreviewProvider {
    static var previews: some View {
        NewTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
