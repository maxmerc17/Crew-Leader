//
//  PlanterProgressView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-20.
//

import SwiftUI

struct PlanterProgressView: View {
    @Binding var block: Block
    
    var body: some View {
        VStack(alignment: .leading){
            Text("hello")
        }.padding()
    }
}

struct PlanterProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterProgressView(block: .constant(Block.sampleData[0]))
    }
}
