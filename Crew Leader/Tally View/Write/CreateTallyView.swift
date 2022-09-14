//
//  NewTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI
// TODO: add proper members to individual tallies
// TODO: add checking so someone can't add a block to the list twice
// TODO: add create new block button - create a block if it doesn't yet exist

struct CreateTallyView: View {
    @Binding var newTallyData : DailyTally.Data
    
    @State var selectedBlock : Block = Block(data: Block.Data())
    @State var selectedPlanter : Person = Crew.sampleCrew.members[0]
    
    @State var partials : [Partial] = []
    @State var newPartialData : Partial.Data = Partial.Data()

    @State var isShowingError : Bool = false
    @State var isShowingTallies : Bool = false
    
    var blocksList : [Block] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    func verifyInput(){
        if blocksList.count > 0 {
            selectedBlock = blocksList[0]
            if newTallyData.blocks.allSatisfy({$1.species.count > 0}){
                isShowingTallies = true
                return
            }
        }
        isShowingError = true
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
                
                AddBlocksView(newTallyData: $newTallyData)
                
            }.scrollContentBackground(.hidden)
            
            VStack{
                Divider()
                if blocksList.count > 0 {
                    AddSpeciesView(newTallyData: $newTallyData,
                                        selectedBlock: blocksList[0])
                    
                    NavigationLink(destination: EnterTallyDataView(newTallyData: $newTallyData, selectedBlock: $selectedBlock, selectedPlanter: $selectedPlanter, partials: $partials, newPartialData: $newPartialData), isActive: $isShowingTallies){
                        
                    }
                }
                
                Button(action: verifyInput){
                    Text("Crew Tallies")
                }.padding()
            }
            
        }.alert(isPresented: $isShowingError) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("One or more blocks must be selected. For each block their must be one or more species selected.")
            )
        }
    }
}
/*
struct ErrorView: View {
    var body: some View {
        ZStack{
            Color.gray.frame(width: UIScreen.main.bounds.size.width*0.6, height: UIScreen.main.bounds.size.height*0.6).cornerRadius(45)
            VStack(alignment: .center) {
                Text("Invalid Input").font(.title)
                Text("One or more blocks must be selected. For each block their must be one or more species selected.").font(.caption)
            }.padding().frame(width: UIScreen.main.bounds.size.width*0.6, height: UIScreen.main.bounds.size.height*0.6).foregroundColor(.white)
        }
    }
}
*/

struct CreateTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
