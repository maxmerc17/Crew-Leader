//
//  EnterTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct EnterTallyView: View {
    @Binding var newTallyData : DailyTally.Data
    @State var selectedPlanter : Person = Person.sampleData[0]
    @State var selectedBlock : Block = Block(data: Block.Data())
    
    @State var newPartialData : Partial.Data = Partial.Data()
    @State var partials : [Partial] = []
    @State var isPresentingCreatePartialView : Bool = false
    
    func addToPartials() {
        let newPartial = Partial(data: newPartialData)
        partials.append(newPartial)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {}){
                    Text("<")
                }
                Picker("Planter", selection: $selectedPlanter){
                    ForEach(Crew.sampleData.members){ member in
                        Text("\(member.fullName)").tag(member)
                    }
                }.pickerStyle(.wheel)
                Button(action: {}){
                    Text(">")
                }
            }.padding()
            
            BlockSwitchView(blocks: Array(newTallyData.blocks.keys), selectedBlock: $selectedBlock)
            Form{
                ForEach(Array(newTallyData.blocks[selectedBlock]?.species ?? [])){
                        species in
                    EnterSpeciesView(newTallyData: $newTallyData, planter: selectedPlanter, species: species, block: selectedBlock, partials: $partials)
                        
                }
            }
        }.popover(isPresented: $isPresentingCreatePartialView){
            CreatePartialView(newTallyData: $newTallyData,
                              isPresentingCreatePartialView: $isPresentingCreatePartialView,
                              newPartialData: $newPartialData,
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

struct EnterTallyView_Previews: PreviewProvider {
    static var previews: some View {
        EnterTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
