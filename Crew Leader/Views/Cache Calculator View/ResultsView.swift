//
//  ResultsView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import SwiftUI

// TODO: percision up to 2 decimal points on actual percentage

struct ResultsView: View {
    @State var calculatedObject : CacheCalculator
    
    var body: some View {
        VStack {
            List{
                Section("Input") {
                    HStack{
                        Label("Desired number of trees", systemImage: "number")
                        //Text("Desired number of trees")
                        Spacer()
                        Text("\(calculatedObject.desiredTrees)")
                    }
                    ForEach(calculatedObject.cuts){ cut in
                        HStack{
                            Label("\(cut.species.name)", systemImage: "leaf")
                            //Text(cut.species.name)
                            Spacer()
                            Text("\(cut.species.treesPerBox) trees / box")
                            Spacer()
                            Text("\(cut.percent)%")
                        }
                    }
                }
                
                Section("Output"){
                    ForEach(calculatedObject.cuts){ cut in
                        HStack{
                            //Label("\(cut.species.name)", systemImage: "leaf")
                            Text("\(cut.species.name)")
                            Spacer()
                            Text("\(cut.numBoxes(calculatedObject.desiredTrees)) boxes").bold()
                            Spacer()
                            Text("\(cut.numBoxes(calculatedObject.desiredTrees) * cut.species.treesPerBox) trees")
                            Spacer()
                            if (calculatedObject.calculateActualPercent(cut: cut) == String(cut.percent)){
                                Text("\(calculatedObject.calculateActualPercent(cut: cut))%").foregroundColor(.green)
                            } else {
                                Text("\(calculatedObject.calculateActualPercent(cut: cut))%").foregroundColor(.red)
                            }
                        }
                    }
                }
                
                Section("Totals"){
    //                HStack{
    //                    //Label("Total Percent", systemImage: "percent")
    //                    Text("Total Percent")
    //                    Spacer()
    //                    if (calculatedObject.totalPercentage == 100) {
    //                        Text("\(calculatedObject.totalPercentage)%").foregroundColor(.green)
    //                    } else {
    //                        Text("\(calculatedObject.totalPercentage)%").foregroundColor(.red)
    //                    }
    //                }
                    HStack{
                        //Label("Total Boxes", systemImage: "shippingbox")
                        Text("Total Boxes")
                        Spacer()
                        Text("\(calculatedObject.totalBoxes)")
                    }
                    HStack{
                        //Label("Total Trees", systemImage: "leaf.fill")
                        Text("Total Trees")
                        Spacer()
                        Text("\(calculatedObject.totalTrees)")
                    }
                    HStack{
                        //Label("Over / Under", systemImage: "plusminus")
                        Text("Over / Under")
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
            Spacer()
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(calculatedObject: CacheCalculator.sampleData[0])
    }
}
