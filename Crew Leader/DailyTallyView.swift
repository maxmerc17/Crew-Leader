//
//  DetailView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//
import SwiftUI

struct DailyTallyView: View {
    @State var tally : DailyTally
    @State var selectedBlock : Block
    
    var body: some View {
            VStack(){
                BlockSwitchView(blocks: Array(tally.blocks.keys), selectedBlock: $selectedBlock)
                
                Form {
                    Section("Trees planted"){
                        Text("\(tally.blocks[selectedBlock]?.treesPlanted ?? 0)")
                    }
                    
                    Section("Species Count"){
                        ForEach(Array(tally.blocks[selectedBlock]?.treesPlantedPerSpecies ?? [:]), id: \.key){
                            species, planted in
                                HStack {
                                    Label("\(species.name)", systemImage: "leaf")
                                    Spacer()
                                    Text("\(planted) trees")
                                }
                        }
                    }
                    
                    Section("Planters"){
                        ForEach(tally.blocks[selectedBlock]?.individualTallies ?? []) {
                            individualTally in
                            NavigationLink(destination: PlanterTallyView(tally: tally, blocks: Array(tally.blocks.keys), selectedBlock: selectedBlock, planterTally: individualTally)){
                                Text("\(individualTally.planter.lastName), \(individualTally.planter.firstName)")
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
        DailyTallyView(tally: DailyTally.sampleData[0], selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0])
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
