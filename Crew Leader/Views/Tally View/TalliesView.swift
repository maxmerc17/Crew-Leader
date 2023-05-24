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
    
    var sortedTallies : [DailyTally] {
        return tallies.sorted(by: { $0.date > $1.date })
    }
    
    @State private var isShowingDeleteAlert = false
    @State private var tallyToDelete: DailyTally?
    @State var isShowingDiscardAlert = false
    @State var isShowingSaveAlert = false
    
    func add_tally(){
        tallies.append(newTallyData)
        isPresentingNewTallyView = false
        newTallyData = DailyTally(data: DailyTally.Data())
        saveTallies()
    }
    
    func deleteTally(tally: DailyTally) {
        if let index = tallies.firstIndex(where: { $0.id == tally.id }) {
            tallies.remove(at: index)
            saveTallies()
        }
    }
    
    
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
            VStack{
                HStack{
                    Text("Long-press a tally to delete it").font(.caption).padding()
                    Spacer()
                }
                List {
                    if tallies.isEmpty {
                        Text("No tallies to view.").foregroundColor(.gray)
                    }
                    ForEach(sortedTallies) { tally in
                        NavigationLink (destination: DailyTallyView(tally: tally,
                                                                    selectedBlock: tally.blocks.first!.key)){ // !! - tally must contain at least one block to be created
                            CardView(tally: tally)
                                .contextMenu {
                                Button(action: {
                                    tallyToDelete = tally
                                    isShowingDeleteAlert = true
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(title: Text("Delete tally"),
                      message: Text("Are you sure you want to delete this tally?"),
                      primaryButton: .destructive(Text("Delete")) {
                          if let tallyToDelete = tallyToDelete {
                              deleteTally(tally: tallyToDelete)
                          }
                      },
                      secondaryButton: .cancel())
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
                                if !newTallyData.blocks.isEmpty {
                                    Button("Discard") {
                                        isShowingDiscardAlert = true
                                    }.alert(isPresented: $isShowingDiscardAlert) {
                                        Alert(title: Text("Discard tally"),
                                              message: Text("Are you sure you want to discard this tally?"),
                                              primaryButton: .destructive(Text("Discard")) {
                                            isPresentingNewTallyView = false
                                            newTallyData = DailyTally(data: DailyTally.Data())
                                        },
                                              secondaryButton: .cancel())
                                    }
                                } else {
                                    Button("Dismiss") {
                                            isPresentingNewTallyView = false
                                            newTallyData = DailyTally(data: DailyTally.Data())
                                        }
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    if verifyInput() {
                                        isShowingSaveAlert = true
                                    }
                                }
                                .alert(isPresented: $isShowingSaveAlert) {
                                    Alert(
                                        title: Text("Save Tally"),
                                        message: Text("Is the date correct?"),
                                        primaryButton: .default(Text("Yes! Please Save.")) {
                                            add_tally()
                                        },
                                        secondaryButton: .cancel()
                                    )
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
