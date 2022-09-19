//
//  AddBlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-13.
//

import SwiftUI

struct AddBlocksView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var initSelectedBlock : String
    
    @State var selectedBlock : String = "" // for picker
    @State var showAlert = false
    
    @EnvironmentObject var blockStore : BlockStore
    
    var blocksList : [String] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var blockObjects : [Block]{
        blocksList.map({ blockString in blockStore.blocks.first(where: { $0.blockNumber == blockString })! })
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
                    ForEach(blockStore.blocks) { block in
                        Text(block.blockNumber).tag(block.blockNumber)
                    }
                }.onChange(of: selectedBlock){ newValue in
                    print(newValue)
                    initSelectedBlock = newValue
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
        .onAppear(){
            selectedBlock = blockStore.blocks[0].blockNumber
        }
    }
}

struct AddBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            AddBlocksView(newTallyData: .constant(DailyTally.Data()), initSelectedBlock: .constant(""))
        }.environmentObject(BlockStore())
    }
}
