//
//  PlanterTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

// TODO: you add in the question marks because children can be nil .. good idea because children can be nil, but in some instances if the child is nil it is an error -- add checks in these areas(?)

struct PlanterTallyView: View {
    @State var tally : DailyTally
    @State var blocks : [String]
    @State var selectedBlock : String
    @State var planter : Person
    @State var planterTally : DailyPlanterTally
    
    var body: some View {
        NavigationView(){
            VStack(){
                BlockSwitchView(blocks: blocks, selectedBlock: $selectedBlock)
                
                Form {
                    Section("Trees planted"){
                        Text("\(tally.blocks[selectedBlock]?.individualTallies[planter.id]?.treesPlanted ?? 0)")
                    }
                    Section("Species") {
                        ForEach(Array(tally.blocks[selectedBlock]?.individualTallies[planter.id]?.treesPerSpecies ?? [:]), id: \.key){
                            species, planted in
                            HStack {
                                Label("\(species.name)", systemImage: "leaf")
                                Spacer()
                                Text("\(planted) trees")
                            }
                        }
                    }
                    
                }
                Spacer()
            }
        }.navigationTitle("\(utilities.formatDate(date: tally.date)) - \(planter.fullName)")
    }
}

struct PlanterTallyView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterTallyView(
            tally: DailyTally.sampleData[0],
            blocks: Array(DailyTally.sampleData[0].blocks.keys),
            selectedBlock: Array(DailyTally.sampleData[0].blocks.keys)[0],
            planter: Person.sampleData[0],
            planterTally: DailyPlanterTally.sampleData[0])
    }
}
