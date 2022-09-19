//
//  BlockSwitchView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct BlockSwitchView: View {
    @State var blocks : [String]
    @Binding var selectedBlock : String
    
    @EnvironmentObject var blockStore: BlockStore
    
    var blockObjects : [Block] {
        blocks.map({ blockString in blockStore.blocks.first(where: { $0.blockNumber == blockString })! })
    }
    
    var body: some View {
        HStack(spacing: 25) {
            ForEach(blockObjects) { block in
                Button {
                    selectedBlock = block.blockNumber
                } label: {
                    HStack {
                        Image(systemName: "map")
                        Text("\(block.blockNumber)")
                    }.font(.system(size: 15))
                        .foregroundColor(block.blockNumber == selectedBlock
                            ? .accentColor
                            : .gray)
                }
            }
        }.padding()
    }
}

struct BlockSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        BlockSwitchView(blocks: Array(DailyTally.sampleData[0].blocks.keys), selectedBlock: .constant(Array(DailyTally.sampleData[0].blocks.keys)[0])).environmentObject(BlockStore())
    }
}

