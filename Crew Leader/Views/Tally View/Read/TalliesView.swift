//
//  TalliesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

// TODO: add validation on the add function to make sure everything is correct before adding

import SwiftUI

struct TalliesView: View {
    @Binding var tallies : [DailyTally] //= DailyTally.sampleData
    let saveTallies : () -> Void
    
    @State var isPresentingNewTallyView : Bool = false
    @State var newTallyData : DailyTally.Data = DailyTally.Data()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tallies) { tally in
                    NavigationLink (destination: DailyTallyView(tally: tally, selectedBlock: Block.sampleData.first(where:  { $0.blockNumber == Array(tally.blocks.keys)[0] } )!.blockNumber)){
                        CardView(tally: tally)
                    }
                }
            }
            .navigationTitle("Tallies")
            .toolbar {
                Button(action: {isPresentingNewTallyView = true}){
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isPresentingNewTallyView){
                NavigationView(){
                    CreateTallyView(newTallyData: $newTallyData)
                        .toolbar(){
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewTallyView = false
                                    newTallyData = DailyTally.Data()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newTally = DailyTally(data: newTallyData)
                                    tallies.append(newTally)
                                    isPresentingNewTallyView = false
                                    newTallyData = DailyTally.Data()
                                    saveTallies()
                                }
                            }
                        }
                }
            }
        }
    }
}

struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        //var tallies = DailyTally.data
        TalliesView(tallies: .constant(DailyTally.sampleData), saveTallies: {})
    }
}
