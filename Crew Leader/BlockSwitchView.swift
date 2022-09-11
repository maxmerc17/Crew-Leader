//
//  BlockSwitchView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct BlockSwitchView: View {
    @State var blocks : [Block]
    @Binding var selectedBlock : Block
    var body: some View {
        HStack(spacing: 25) {
            ForEach(blocks) { block in
                Button {
                    selectedBlock = block
                } label: {
                    Text("\(block.blockNumber)")
                        .font(.system(size: 15))
                        .foregroundColor(block == selectedBlock
                            ? .accentColor
                            : .gray)
                        .animation(nil)
                }
            }
        }.padding()
    }
}

struct BlockSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        BlockSwitchView(blocks: Array(DailyTally.sampleData[0].blocks.keys), selectedBlock: .constant(Array(DailyTally.sampleData[0].blocks.keys)[0]))
    }
}

