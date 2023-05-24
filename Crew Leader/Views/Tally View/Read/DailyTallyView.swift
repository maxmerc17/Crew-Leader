//
//  DetailView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//
import SwiftUI

struct DailyTallyView: View {
    @State var tally : DailyTally
    @State var selectedBlock : String
    
    @EnvironmentObject var personStore: PersonStore
    
    @State var isShowingConfirmationAlert: Bool = false
    
    var body: some View {
        let treesPlantedPerSpecies : [Species : Int] = tally.getTreesPlantedPerSpecies(block: selectedBlock) ?? [:] // ???? - unwraps if it exists and or returns [:] if nil
        
        let individualTallies : [UUID: DailyPlanterTally] = tally.getIndividualTallies(block: selectedBlock) ?? [:] // ????
        
        VStack(){
            BlockSwitchView(blocks: Array(tally.blocks.keys), selectedBlock: $selectedBlock)
            
            Form {
                Section("Trees planted"){
                    Text("\(tally.getTreesPlanted(block: selectedBlock) ?? 0)")
                }
                
                Section("Species Count"){
                    ForEach(treesPlantedPerSpecies.sorted(by: >), id: \.key){ // why sorted - required to be sorted to work
                        species, planted in
                            HStack {
                                Label("\(species.name)", systemImage: "leaf")
                                Spacer()
                                Text("\(planted) trees")
                            }
                    }
                }
                
                Section("Planters"){
                    ForEach(Array(individualTallies), id: \.key) { // why array - gets rid of the error
                        planterId, individualTally in
                        let planter = personStore.getPlanter(id: planterId)!
                        NavigationLink(destination: PlanterTallyView(tally: tally, blocks: Array(tally.blocks.keys), selectedBlock: selectedBlock, planter: planter ,planterTally: individualTally)){
                            Text("\(planter.lastName), \(planter.firstName)")
                        }
                        
                    }
                }
                /*Section(""){
                    Button(action: { self.isShowingConfirmationAlert = true } ){
                        HStack{
                            Spacer()
                            HStack{
                                Text("DELETE").foregroundColor(.red).fontWeight(.heavy).font(.custom("Helvetica Bold", size: 18))
                                Image(systemName: "trash.circle.fill").foregroundColor(.red)
                            }.font(.system(size: 30))
                            Spacer()
                        }
                        
                        
                    }.buttonStyle(PlainButtonStyle())
                }*/
                
            }
            
            
            Spacer()
        }
        .navigationTitle("\(utilities.formatDate(date: tally.date))")
            .alert(isPresented: $isShowingConfirmationAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This tally will be permanently deleted."),
                primaryButton: .destructive(Text("Delete")) {
                    // Add your delete action here
                },
                secondaryButton: .cancel()
            )
        }
    }
}

func nil_func() -> Void {}


struct DailyTallyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTallyView(tally: DailyTally.sampleData[0], selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0]).environmentObject(PersonStore())
    }
}


/*
Section("Planters"){
    ForEach(tally.blocks[selectedBlock]?.individualTallies ?? []) {
        individualTally in
        //NavigationLink(destination: IndiviualTallyView)
        Text("\(individualTally.planter.lastName), \(individualTally.planter.firstName)")
    }
}*/
