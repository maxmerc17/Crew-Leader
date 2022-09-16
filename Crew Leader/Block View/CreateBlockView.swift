//
//  CreateBlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct CreateBlockView: View {
    @Binding var newBlockData : Block.Data
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct CreateBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBlockView(newBlockData: .constant(Block.Data()))
    }
}
