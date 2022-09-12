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
    
    @State var partialData : Partial.Data = Partial.Data()
    @State var partials : [Partial] = []
    @State var isPresentingCreatePartialView : Bool = false
    
    
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
            CreatePartialView(isPresentingCreatePartialView: $isPresentingCreatePartialView, partialData: $partialData)
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
