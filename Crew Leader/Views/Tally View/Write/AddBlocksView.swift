//
//  AddBlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-13.
//

import SwiftUI

struct AddBlocksView: View {
    @Binding var newTallyData : DailyTally.Data
    
    @State var selectedBlock : String = Block.sampleData[0].blockNumber // for picker
    @State var showAlert = false
    
    var blocksList : [String] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var blockObjects : [Block]{
        blocksList.map({ blockString in Block.sampleData.first(where: { $0.blockNumber == blockString })! })
    }
    
    func newBlockClicked(){
        if !blocksList.contains(selectedBlock) {
            var dbt = DailyBlockTally(data: DailyBlockTally.Data())
            for member in Crew.sampleCrew.members{
                dbt.individualTallies[member] = DailyPlanterTally(data: DailyPlanterTally.Data())
            }
            newTallyData.blocks[selectedBlock] = dbt
        } else {
            showAlert = true
        }
            
    }
    
    var body: some View {
        Section("Blocks"){
            ForEach(blockObjects) { block in
                Label("\(block.blockNumber)", systemImage: "map")
            }
            
            HStack {
                Picker("Add Block", selection: $selectedBlock){
                    ForEach(Block.sampleData) { block in
                        Text(block.blockNumber).tag(block.blockNumber)
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
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Cannot Add Selected Block To List"),
                message: Text("The selected block is already in the list.")
            )
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
