//
//  BlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlocksView: View {
    @Binding var blocks : [Block]
    let saveBlocks: () -> Void
    
    @State var isPresentingNewBlockView : Bool = false
    @State var newBlockData : Block.Data = Block.Data()
    
    @State var selectedCategory = "Progress"
    
    var sortedBlocks : [Block] {
        return blocks.sorted(by: { $0.blockDetails.workStartDate >  $1.blockDetails.workStartDate})
    }
    
    var body: some View {
        NavigationView {
            List {
                if blocks.isEmpty {
                    Text("No blocks to view").foregroundColor(.gray)
                }else {
                    ForEach(sortedBlocks) { block in
                        NavigationLink (destination: BlockView(block: block, selectedCategory: $selectedCategory)){
                            BlockCardView(block: block)
                        }
                    }
                }
                
            }
            .navigationTitle("Blocks")
            .toolbar {
                Button(action: {isPresentingNewBlockView = true}){
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPresentingNewBlockView){
                NavigationView(){
                    CreateBlockView(newBlockData: $newBlockData,
                                    blocks : $blocks,
                                    isPresentingNewBlockView: $isPresentingNewBlockView,
                                    saveBlocks: saveBlocks)
                        .toolbar(){
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewBlockView = false
                                    newBlockData = Block.Data()
                                }
                            }
                            
                        }
                }
            }
        }
    }
}

struct BlocksView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksView(blocks: .constant(Block.sampleData), saveBlocks: {})
    }
}
