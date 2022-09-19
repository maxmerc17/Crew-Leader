//
//  CardView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct CardView: View {
    let tally: DailyTally
    func getListOfBlocks() -> String {
        var returnString : String = ""
        for (key , _) in  tally.blocks {
            returnString += key + (", ")//block.blockNumber
        }
        returnString = String(returnString.dropLast(2))
        
        return returnString
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(utilities.formatDate(date: tally.date))")
                .font(.headline)
        
            Spacer()
            HStack {
                Label("\(getListOfBlocks())", systemImage: "map")
                Spacer()
            }
            .font(.caption)
        }
        .padding()
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var tally = DailyTally.sampleData[0]
    static var previews: some View {
    CardView(tally: tally)
        .previewLayout(.fixed(width: 400, height: 60))
    }
}
