//
//  DetailView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//
import SwiftUI

struct DetailView: View {
    @State var tally : DailyTally
    @State var selectedBlock : Block
    
    var body: some View {
        NavigationView(){
            VStack(){
                BlockSwitchView(blocks: Array(tally.blocks.keys), selectedBlock: $selectedBlock)
                
                Form {
                    Section("Trees planted"){
                        Text("\(tally.blocks[selectedBlock]?.treesPlanted ?? 0)")
                    }
                    
                    ForEach(Array(tally.blocks[selectedBlock]?.treesPlantedPerSpecies ?? [:]), id: \.key){
                        species, planted in
                            Section("\(species.name) planted"){
                                Text("\(planted)")
                            }
                    }
                    
                    Section("Planters"){
                        ForEach(tally.blocks[selectedBlock]?.individualTallies ?? []) {
                            individualTally in
                            //NavigationLink(destination: IndiviualTallyView)
                            Text("\(individualTally.planter.lastName), \(individualTally.planter.firstName)")
                        }
                    }
                    
                }
                
                Spacer()
            }
        }.navigationTitle("\(utilities.formatDate(date: tally.date))")
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(tally: DailyTally.sampleData[0], selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0])
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
