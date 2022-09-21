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
                
            }
            
            Spacer()
        }.navigationTitle("\(utilities.formatDate(date: tally.date))")
    }
}

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
