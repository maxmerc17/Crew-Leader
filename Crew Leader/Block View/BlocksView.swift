//
//  BlocksView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlocksView: View {
    @State var blocks : [Block] = Block.sampleData
    
    @State var isPresentingNewBlockView : Bool = false
    @State var newBlockData : Block.Data = Block.Data()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(blocks) { block in
                    NavigationLink (destination: BlockView(block: block)){
                        BlockCardView(block: block)
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
                    CreateBlockView(newBlockData: $newBlockData)
                        .toolbar(){
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewBlockView = false
                                    newBlockData = Block.Data()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newBlock = Block(data: newBlockData)
                                    blocks.append(newBlock)
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
        BlocksView()
    }
}
