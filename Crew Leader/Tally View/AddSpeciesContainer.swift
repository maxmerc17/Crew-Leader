//
//  BlockSwitchView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

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
    @State var selectedBlock : Block = Block(data: Block.Data())//blocks[0]

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
