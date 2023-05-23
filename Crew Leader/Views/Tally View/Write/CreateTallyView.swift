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
    
    @State var canDisplay: Bool = false
    
    var blocksList : [String] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    @EnvironmentObject var personStore : PersonStore
    @EnvironmentObject var blockStore: BlockStore
    @EnvironmentObject var speciesStore: SpeciesStore
    @EnvironmentObject var talliesStore: TallyStore
    
    func load() {
        if selectedPlanter.fullName == " "{
            if personStore.persons.isEmpty || blockStore.blocks.isEmpty || speciesStore.species.isEmpty {
                canDisplay = false
            } else {
                selectedPlanter = personStore.getCrew()[0] /// FOD
                canDisplay = true
            }
            
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
    
    @State var textToggle : Bool = true
    
    var body: some View {
        if canDisplay {
            VStack(alignment: .leading, spacing: 0) {
                VStack {
                    Text("Reminder: Be careful. You can only delete tallies, there's no way to update them. Also you cannot update/delete blocks, species, or partials in this module. So maybe write your numbers on paper first and oh ya ... don't fuck it up. Get the DATE right!!! (play around with scrolling if you can't find something)").frame(height: { textToggle ? 50 : 150 }()).font(.custom(
                        "AmericanTypewriter",
                        fixedSize: 16)).padding(.leading, 10)
                    Button(action: { self.textToggle = !self.textToggle }){
                        Label("", systemImage: { textToggle ? "arrow.down" : "arrow.up" }() )
                    }
                }
                
                
                Form {
                    Section("Block Information"){
                        HStack{
                            Label("Date", systemImage: "calendar")
                            Spacer()
                            DatePicker(selection: $newTallyData.date, displayedComponents: .date, label: { Text("")})
                        }
                    }
                }.frame(height: 100)
                
                
                Form {
                    AddBlocksView(newTallyData: $newTallyData, initSelectedBlock: $selectedBlock).frame(height: 5)
                }.scrollContentBackground(.hidden)
                
                VStack{
                    //Divider()
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
                    HStack{
                        Spacer()
                        Button(action: verifyInput){
                            Text("View Crew Tallies").foregroundColor(.green)
                        }.padding()
                        Spacer()
                    }
                    
                }.scrollContentBackground(.hidden)
                    .frame(height: 300)
                
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
        else {
            VStack{
                Text("Cannot create tally due to lack of crew, species, or block data.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                Text("Data may be taking longer to load. Or no data exists.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                Button(action: load){
                    Label("Reload", systemImage: "arrow.clockwise")
                }.padding()
            }.padding()
            
        }
    }
}

struct CreateTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTallyView(newTallyData: .constant(DailyTally.sampleData[0]), isShowingAlert: .constant(false), alertText: .constant(alertTextType()))
    }
}
