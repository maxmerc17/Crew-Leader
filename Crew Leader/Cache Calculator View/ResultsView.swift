//
//  ResultsView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import SwiftUI

struct ResultsView: View {
    @State var calculatedObject : CacheCalculator
    
    var body: some View {
        List{
            Section("Input") {
                HStack{
                    Label("Desired number of trees", systemImage: "number")
                    Spacer()
                    Text("\(calculatedObject.numTrees)")
                }
            }
            
            Section("Species"){
                ForEach(calculatedObject.cuts){ cut in
                    HStack{
                        Label("\(cut.species.name), \(cut.percent)%", systemImage: "leaf")
                        Spacer()
                        Text("\(cut.numBoxes(calculatedObject.numTrees)) boxes")
                        Spacer()
                        Text("\(cut.numBoxes(calculatedObject.numTrees) * cut.species.numTrees) trees")
                        //Text("\(cut.species.name), \(cut.numBoxes(calculatedObject.numTrees))")
                    }
                }
            }
            
            Section("Totals"){
                HStack{
                    Label("Total Boxes", systemImage: "square.fill")
                    Spacer()
                    Text("\(calculatedObject.totalBoxes)")
                }
                HStack{
                    Label("Total Trees", systemImage: "leaf.fill")
                    Spacer()
                    Text("\(calculatedObject.totalTrees)")
                }
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(calculatedObject: CacheCalculator.sampleData[0])
    }
}
