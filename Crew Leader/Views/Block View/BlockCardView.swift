//
//  BlockCardView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlockCardView: View {
    @State var block : Block
    
    func getDateString() -> String{
        var s = utilities.formatDate(date: block.blockDetails.workStartDate)
        if let finishDate = block.blockDetails.workFinishDate{
            s += " -> \(utilities.formatDate(date:finishDate))"
        }
        return s
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(block.blockNumber)").font(.headline)
        
            Spacer()
            HStack {
                Label("\(getDateString())", systemImage: "calendar")
                Spacer()
            }
            .font(.caption)
        }.padding()
    }
}

struct BlockCardView_Previews: PreviewProvider {
    static var previews: some View {
        BlockCardView(block: Block.sampleData[0])
    }
}
