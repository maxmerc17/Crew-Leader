//
//  BlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlockView: View {
    @Binding var block : Block
    var body: some View {
        VStack {
            List{
                NavigationLink(destination: PlantingSummaryView(block: block)){
                    Text("Planting Summary")
                }
                
            }
        }.navigationTitle("\(block.blockNumber)")
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: .constant(Block.sampleData[0]))
    }
}
