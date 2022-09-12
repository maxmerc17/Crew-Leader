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
    
    var body: some View {
        ScrollView {
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
            
            /*Form {
                ForEach(newTallyData.blocks[selectedBlock].)
            }*/
        }
    }
}

struct EnterTallyView_Previews: PreviewProvider {
    static var previews: some View {
        EnterTallyView(newTallyData: .constant(DailyTally.Data()))
    }
}
