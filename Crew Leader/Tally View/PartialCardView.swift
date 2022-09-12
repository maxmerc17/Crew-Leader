//
//  PartialCardView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct PartialCardView: View {
    var partial : Partial
    
    func partialString() -> String {
        var returnString = ""
        for planter in partial.people{
            returnString += "\(planter.key.firstName) - \(planter.value), "
        }
        returnString = String(returnString.dropLast(2))
        
        return returnString
    }
    var body: some View {
        VStack(alignment: .leading) {
            //Text("\(partial.species.name) Partial").font(.headline)//Text("\(Array(partial.people.keys)[0].firstName)'s Partial")
            HStack {
                Label("\(partialString())", systemImage: "square.slash")
                
            }
        }
        
    }
}

struct PartialCardView_Previews: PreviewProvider {
    static var previews: some View {
        PartialCardView(partial: Partial.sampleData[0])
        .previewLayout(.fixed(width: 400, height: 60))
    }
}
