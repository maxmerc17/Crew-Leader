//
//  AddBlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-13.
//

/// TODO: be able to add more than just crew to a block. Be able to add guests. Implementation for this is here
///
/// may want to change design of how individual tallies are created here. Works good now, may need redesign for adding guest planters
///
/// TODO: not sure if I still need initSelectedBlock. It was a workaround. May not need it anymore

import SwiftUI

struct AddBlocksView: View {
    /// passed data
    @Binding var newTallyData : DailyTally.Data
    @Binding var initSelectedBlock : String
    
    @State var selectedBlock : String = "" // for picker
    
    @State var showAlert = false
    
    @EnvironmentObject var blockStore : BlockStore
    @EnvironmentObject var personStore : PersonStore
    
    var blocksList : [String] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    var blockObjects : [Block]{
        blocksList.map({ blockString in blockStore.getBlock(blockName: blockString)! }) /// !! - unwrap should be good
    }
    
    func newBlockClicked(){
        if !blocksList.contains(selectedBlock) {
            var dbt = DailyBlockTally(data: DailyBlockTally.Data())
            for member in personStore.getCrew(){
                dbt.individualTallies[member.id] = DailyPlanterTally(data: DailyPlanterTally.Data())
            }
            // add the add guests code here
            
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
            selectedBlock = blockStore.blocks[0].blockNumber /// FOD
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
