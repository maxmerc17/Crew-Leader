//
//  BlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlockView: View {
    @State var block : Block
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block.sampleData[0])
    }
}
