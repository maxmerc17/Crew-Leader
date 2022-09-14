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
                    Text("\(calculatedObject.desiredTrees)")
                }
                ForEach(calculatedObject.cuts){ cut in
                    HStack{
                        Label("\(cut.species.name)", systemImage: "leaf")
                        Spacer()
                        Text("\(cut.species.numTrees) trees / box")
                        Spacer()
                        Text("\(cut.percent)%")
                    }
                }
            }
            
            Section("Output"){
                ForEach(calculatedObject.cuts){ cut in
                    HStack{
                        Label("\(cut.species.name)", systemImage: "leaf")
                        Spacer()
                        Text("\(cut.numBoxes(calculatedObject.desiredTrees)) boxes").bold()
                        Spacer()
                        Text("\(cut.numBoxes(calculatedObject.desiredTrees) * cut.species.numTrees) trees")
                    }
                }
            }
            
            Section("Totals"){
                HStack{
                    Label("Total Percent", systemImage: "percent")
                    Spacer()
                    if (calculatedObject.totalPercentage == 100) {
                        Text("\(calculatedObject.totalPercentage)%").foregroundColor(.green)
                    } else {
                        Text("\(calculatedObject.totalPercentage)%").foregroundColor(.red)
                    }
                }
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
                HStack{
                    Label("Over / Under", systemImage: "plusminus")
                    Spacer()
                    if (calculatedObject.desiredTrees < calculatedObject.totalTrees){
                        Text("+\(calculatedObject.totalTrees - calculatedObject.desiredTrees)").foregroundColor(.green)
                    } else if (calculatedObject.desiredTrees > calculatedObject.totalTrees) {
                        Text("\(calculatedObject.totalTrees - calculatedObject.desiredTrees)").foregroundColor(.red)
                    } else { // if they are equal .. this should be zero
                        Text("\(calculatedObject.totalTrees - calculatedObject.desiredTrees)").foregroundColor(.green)
                    }
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
