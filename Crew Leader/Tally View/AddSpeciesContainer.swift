//
//  BlockSwitchView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

// TODO: have the first block on the list automatically selected - displaying it's content
// TODO: add a transition where the block data slides in when different blocks are selected

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct AddSpeciesContainer: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var blocks : [Block]
    @State var selectedBlock : Block = Block(data: Block.Data())

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
            
            if selectedBlock.blockNumber != ""{
                AddSpeciesView(newTallyData: $newTallyData, selectedBlock: $selectedBlock).transition(.move(edge: .trailing))
            }
            
        }.onAppear(){
            //selectedBlock = blocks[0]
        }
    }
}

struct AddSpeciesContainer_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesContainer(newTallyData: .constant(DailyTally.Data()),
                            blocks: .constant(Array(DailyTally.sampleData[0].blocks.keys)))
    }
}
