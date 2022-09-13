//
//  AddBlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-13.
//

import SwiftUI

struct AddBlocksView: View {
    @Binding var newTallyData : DailyTally.Data
    
    @State var selectedBlock : Block = Block.sampleData[0] // for picker
    
    var blocksList : [Block] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    func newBlockClicked(){
        var dbt = DailyBlockTally(data: DailyBlockTally.Data())
        for member in Crew.sampleCrew.members{
            dbt.individualTallies[member] = DailyPlanterTally(data: DailyPlanterTally.Data())
        }
        newTallyData.blocks[selectedBlock] = dbt
    }
    
    var body: some View {
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
}

struct AddBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            AddBlocksView(newTallyData: .constant(DailyTally.Data()))
        }
    }
}
