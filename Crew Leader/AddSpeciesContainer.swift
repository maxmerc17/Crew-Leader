//
//  BlockSwitchView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct AddSpeciesContainer: View {
    @Binding var blocks : [Block]
    @Binding var selectedBlock : Block

    var body: some View {
        VStack {
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
            
            //AddSpeciesView()
        }
    }
}

struct AddSpeciesContainer_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesContainer(blocks: .constant(Array(DailyTally.sampleData[0].blocks.keys)), selectedBlock: .constant(Array(DailyTally.sampleData[0].blocks.keys)[0]))
    }
}
