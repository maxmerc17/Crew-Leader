//
//  EnterTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

// TODO: selectedblock and selectedplanter should be the same when you leave and come back to the page

import SwiftUI

struct EnterTallyDataView: View {
    @Binding var newTallyData : DailyTally.Data
    @Binding var selectedBlock : String
    @Binding var selectedPlanter : Person
    
    @Binding var partials : [Partial]
    @Binding var newPartialData : Partial.Data
    
    @State var isPresentingCreatePartialView : Bool = false
    
    func addToPartials() {
        let newPartial = Partial(data: newPartialData)
        partials.append(newPartial)
    }
    
    var body: some View {
        VStack {
            Picker("Planter", selection: $selectedPlanter){
                ForEach(Crew.sampleData.members){ member in
                    Text("\(member.fullName)").tag(member)
                }
            }.pickerStyle(.wheel)
            
            BlockSwitchView(blocks: Array(newTallyData.blocks.keys), selectedBlock: $selectedBlock)
            Form{
                ForEach(Array(newTallyData.blocks[selectedBlock]?.species ?? [])){
                        species in
                    EnterSpeciesView(newTallyData: $newTallyData, planter: $selectedPlanter, species: species, block: $selectedBlock, partials: $partials)
                }
            }
            Text("\(selectedPlanter.firstName) has planted \(newTallyData.blocks[selectedBlock]?.individualTallies[selectedPlanter]?.treesPlanted ?? 0) trees for \(selectedBlock)")
        }.popover(isPresented: $isPresentingCreatePartialView){
            CreatePartialView(newTallyData: $newTallyData,
                              newPartialData: $newPartialData,
                              isPresentingCreatePartialView: $isPresentingCreatePartialView,
                              selectedSpecies:  (newTallyData.blocks[selectedBlock]?.species[0])!,
                              selectedBlock: selectedBlock,
                              selectedPlanter: selectedPlanter,
                              partials: $partials)
        }.toolbar(){
            ToolbarItem(placement: .primaryAction){
                Button("New Partial"){
                    isPresentingCreatePartialView = true
                }
            }
        }
    }
}

struct EnterTallyDataView_Previews: PreviewProvider {
    static var previews: some View {
        EnterTallyDataView(newTallyData: .constant(DailyTally.Data()), selectedBlock: .constant(Block.sampleData[0].blockNumber), selectedPlanter: .constant(Crew.sampleCrew.members[0]), partials: .constant([Partial(data: Partial.Data())]), newPartialData: .constant(Partial.Data())).environmentObject(BlockStore())
    }
}
