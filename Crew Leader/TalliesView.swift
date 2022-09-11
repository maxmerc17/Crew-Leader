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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tallies) { tally in
                    NavigationLink (destination: DailyTallyView(tally: tally, selectedBlock: Array(tally.blocks.keys)[0])){
                        CardView(tally: tally)
                    }
                }
            }.navigationTitle("Tallies")
                .toolbar {
                    Button(action: {isPresentingNewTallyView = true}){
                        Image(systemName: "plus")
                    }
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
