//
//  PlanterProgressView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-20.
//

import SwiftUI
import Charts

struct PlanterProgressView: View {
    @Binding var block: Block
    
    @State var peopleList : [Person] = Crew.sampleData.members
    @State var treesPerDayData : [(day: String, trees: Int)] = []
    @State var selectedPerson : Person = Person(data: Person.Data())
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateTreesPerDayData() {
        treesPerDayData = tallyStore.getTreesPerDate(block: block.blockNumber, person: selectedPerson)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
//                Picker("Planter", selection: $selectedPlanter){
//                    ForEach(Crew.sampleData.members){ member in
//                        Text("\(member.fullName)").tag(member)
//                    }
//                }.pickerStyle(.wheel)
                
                Chart{
                    ForEach(treesPerDayData, id: \.day){ item in
                        BarMark(
                            x: .value("Day", item.day),
                            y: .value("Trees Planted", item.trees)
                        ).annotation{
                            Text("\(item.trees)")
                        }
                    }
                }.frame(height: 300)
            }
                
        }.navigationTitle("Planter Progress")
        .onAppear(){
            selectedPerson = peopleList[0]
            updateTreesPerDayData()
        }
    }
}

struct PlanterProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterProgressView(block: .constant(Block.sampleData[0])).environmentObject(TallyStore())
    }
}

struct TreesPerDay: Identifiable {
    var day: String
    var trees: Double
    var id = UUID()
}
