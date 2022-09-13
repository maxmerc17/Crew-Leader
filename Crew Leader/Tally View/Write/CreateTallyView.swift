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
    
    @State var selectedBlock : Block = Block.sampleData[0] // for picker
    
    @State var isShowingError : Bool = false
    @State var isShowingTallies : Bool = false
    
    var blocksList : [Block] {
        get {
            return Array(newTallyData.blocks.keys)
        }
    }
    
    func newBlockClicked(){
        var dbt = DailyBlockTally(data: DailyBlockTally.Data())
        for member in Crew.sampleCrew.members{
            dbt.individualTallies[member] = DailyPlanterTally(data: DailyPlanterTally.Data())
        }
        newTallyData.blocks[selectedBlock] = dbt
    }
    
    func verifyInput(){
        if blocksList.count > 0 {
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
                Section("Blocks"){
                    ForEach(blocksList) { block in
                        Label("\(block.blockNumber)", systemImage: "map")
                    }
                    
                    HStack {
                        Picker("Add Block", selection: $selectedBlock){
                            ForEach(Block.sampleData) { block in
                                Text(block.blockNumber).tag(block)
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action : newBlockClicked){
                            Text("Add")
                        }
                        Spacer()
                    }
                }
            }
            
            VStack{
                Divider()
                if blocksList.count > 0 {
                    
                    AddSpeciesView(newTallyData: $newTallyData,
                                        selectedBlock: selectedBlock)
                    
                    NavigationLink(destination: EnterTallyDataView(newTallyData: $newTallyData, selectedBlock: blocksList[0]), isActive: $isShowingTallies){
                    }
                    
                }
                
                Button(action: verifyInput){
                    Text("Crew Tallies")
                }
            }
            
        }.popup(isPresented: $isShowingError) {
            ErrorView()
        }
        
    }
}

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

struct CreateTallyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
