//
//  BlockProgressView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-20.
//

import SwiftUI

struct BlockProgressView: View {
    @Binding var block: Block
    
    @State var treesPerDayData : [(day: String, trees: Int)] = []
    
    var body: some View {
        VStack(alignment: .leading){
            Text("hello")
        }.padding()
    }
}

struct BlockProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BlockProgressView(block: .constant(Block.sampleData[0]))
    }
}
