//
//  TalliesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import SwiftUI

struct TalliesView: View {
    @State var isPresentingNewTallyView : Bool = false
    @State var tallies : [DailyTally] = DailyTally.sampleData
    
    @State var newTally : DailyTally = DailyTally(data: DailyTally.Data())
    
    //@State var newTally : DailyTally
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tallies) { tally in
                    NavigationLink (destination: DailyTallyView(tally: tally, selectedBlock: Array(tally.blocks.keys)[0])){
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
                    NewTallyView(newTally: $newTally)
                }
                /*NavigationView {
                    DetailEditView(data: $newScrumData)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newScrum = DailyScrum(data: newScrumData)
                                    scrums.append(newScrum)
                                    isPresentingNewScrumView = false
                                    newScrumData = DailyScrum.Data()
                                }
                            }
                        }
                }*/
            }
        }
        
    }
}

struct TalliesView_Previews: PreviewProvider {
    static var previews: some View {
        //var tallies = DailyTally.data
        TalliesView(tallies: DailyTally.sampleData)
    }
}
