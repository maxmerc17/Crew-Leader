//
//  NewTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct NewTallyView: View {
    @Binding var newTally : DailyTally
    
    @State var selectedBlock : Block = Block(data: Block.Data())
    @State var selectedDate : Date = Date.now
    
    @State var blocksList : [Block] = []//Block.sampleData
    
    @State var toggleSelectedBlock : Block = Block(data: Block.Data())
    
    func newBlockClicked(){
        blocksList.append(selectedBlock)
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
            
                AddSpeciesContainer(blocks: $blocksList, selectedBlock: $toggleSelectedBlock)
           
                
            }
        }
        
    }
}

struct NewTallyView_Previews: PreviewProvider {
    static var previews: some View {
        NewTallyView(newTally: .constant(DailyTally(data: DailyTally.Data())))
    }
}
