//
//  TalliesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

// TODO: add validation on the add function to make sure everything is correct before adding
// TODO: be able to delete a tally

import SwiftUI

struct TalliesView: View {
    @Binding var tallies : [DailyTally] // binding to data store
    let saveTallies : () -> Void
    
    @State var isPresentingNewTallyView : Bool = false
    @State var newTallyData : DailyTally = DailyTally(data: DailyTally.Data())
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @EnvironmentObject var blockStore : BlockStore
    
    func verifyInput() -> Bool { // verify input for save
        if newTallyData.blocks.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "One or more blocks must be selected to submit a tally. Select one or more blocks."
            isShowingAlert = true
            return false
        }
        
        if !newTallyData.blocks.allSatisfy({!$1.species.isEmpty}) {
            alertText.title = "Improper Input"
            alertText.message = "Each block must have one ore more species selected for that block."
            isShowingAlert = true
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationView {
            List {
                if tallies.isEmpty {
                    Text("No tallies to view.").foregroundColor(.gray)
                }
                ForEach(tallies) { tally in
                    NavigationLink (destination: DailyTallyView(tally: tally,
                                                                selectedBlock: tally.blocks.first!.key)){ // !! - tally must contain at least one block to be created
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
                    CreateTallyView(newTallyData: $newTallyData, isShowingAlert: $isShowingAlert, alertText: $alertText)
                        .toolbar(){
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewTallyView = false
                                    newTallyData = DailyTally(data: DailyTally.Data())
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    if verifyInput() {
                                        //let newTally = DailyTally(data: newTallyData)
                                        tallies.append(newTallyData)
                                        isPresentingNewTallyView = false
                                        newTallyData = DailyTally(data: DailyTally.Data())
                                        saveTallies()
                                    }
                                    
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
        TalliesView(tallies: .constant(DailyTally.sampleData), saveTallies: {}).environmentObject(BlockStore())
    }
}
