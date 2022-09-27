//
//  NewTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI
// TODO: be able to remove species / blocks from the list .. it'll get more complicated because you have to delete any previous data on a block or species that was saved to new tally data
// TODO: add proper members to individual tallies .. add people to tally view
// TODO: add create new block button - create a block if it doesn't yet exist

struct CreateTallyView: View {
    @Binding var newTallyData : DailyTally
    
    /// for pickers
    @State var selectedBlock : String = ""
    
    /// keep track of selected planter in child views. Including wheel picker in EnterTallyDataView
    @State var selectedPlanter : Person = Person(data: Person.Data())  /// updatedOnAppear ,  FOD

    
    @State var partials : [Partial] = []
    @State var newPartialData : Partial = Partial(data: Partial.Data())
    
    @Binding var isShowingAlert : Bool
    @Binding var alertText : alertTextType
    
    @State var isShowingTallies : Bool = false
    
    var blocksList : [String] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    @EnvironmentObject var personStore : PersonStore
    
    func load() {
        if selectedPlanter.fullName == " "{
            selectedPlanter = personStore.getCrew()[0] /// FOD
            print(selectedPlanter)
        }
    }
    
    func verifyInput(){
        if blocksList.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "One or more blocks must be selected. For each block there must be one or more species selected."
            isShowingAlert = true
            return
        }
        
        if !newTallyData.blocks.allSatisfy({$1.species.count > 0}){
            alertText.title = "Improper Input"
            alertText.message = "One or more species must be selected for each selected block."
            isShowingAlert = true
            return
        }
        
        isShowingTallies = true
        return
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section("Block Information"){
                    HStack{
                        Label("Date", systemImage: "calendar")
                        Spacer()
                        DatePicker(selection: $newTallyData.date, displayedComponents: .date, label: { Text("")})
                    }
                }
                
                AddBlocksView(newTallyData: $newTallyData, initSelectedBlock: $selectedBlock)
                
            }.scrollContentBackground(.hidden)
            
            VStack{
                Divider()
                if blocksList.count > 0 {
                    AddSpeciesView(newTallyData: $newTallyData,
                                   selectedBlock: blocksList[0],
                                   showAlert: $isShowingAlert,
                                   alertText: $alertText)
                    
                    NavigationLink(destination: EnterTallyDataView(newTallyData: $newTallyData,
                                                                   selectedBlock: $selectedBlock,
                                                                   selectedPlanter: $selectedPlanter,
                                                                   partials: $partials,
                                                                   newPartialData: $newPartialData),
                                   isActive: $isShowingTallies){
                        EmptyView()
                        
                    }
                }
                
                Button(action: verifyInput){
                    Text("Crew Tallies")
                }.padding()
            }
            
        }
        .onAppear(){
            load()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text(alertText.title),
                message: Text(alertText.message)
            )
        }
    }
}

struct CreateTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTallyView(newTallyData: .constant(DailyTally.sampleData[0]), isShowingAlert: .constant(false), alertText: .constant(alertTextType()))
    }
}
