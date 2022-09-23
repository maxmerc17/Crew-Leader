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
    
    @State var peopleList : [Person] = [] /// updateOnAppear
    @State var treesPerDayData : [(day: String, trees: Int)] = [] /// updateOnAppear
    @State var selectedPerson : Person = Person(data: Person.Data()) /// updateOnAppear
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    var total : Int{
        return treesPerDayData.reduce(0) { tot, elem in tot + elem.trees }
    }
    
    var maxVal : Int {
        return treesPerDayData.max { $0.trees < $1.trees }?.trees ?? 0
    }
    
    var averageVal : Int {
        var average : Float = 0
        if !treesPerDayData.isEmpty {
            average = Float(total) / Float(treesPerDayData.count)
        }
        
        return Int(average)
    }
    
    func updateTreesPerDayData() {
        treesPerDayData = tallyStore.getTreesPerDate(block: block.blockNumber, person: selectedPerson)
    }
    
    var body: some View {
        ScrollView{
            List {
                Section("Select Planter"){
                    HStack {
                        Label("Planter", systemImage: "person")
                        Spacer()
                        Picker("", selection: $selectedPerson){
                            ForEach(peopleList){ member in
                                Text("\(member.fullName)").tag(member)
                            }
                        }.onChange(of: selectedPerson){ val in
                            //print(val)
                            updateTreesPerDayData()
                        }
                    }
                }
            }
            .scrollDisabled(true)
            .frame(height: 80)
            
            VStack {
                if treesPerDayData.isEmpty{
                    Button(action: updateTreesPerDayData){
                        Label("Reload", systemImage: "arrow.clockwise")
                    }
                } else {
                    Text("\(selectedPerson.firstName)'s Daily Production for \(block.blockNumber)").font(.title3).padding().multilineTextAlignment(.center)
                    Chart{
                        ForEach(treesPerDayData, id: \.day){ item in
                            BarMark(
                                x: .value("Day", item.day),
                                y: .value("Trees Planted", item.trees)
                            ).annotation{
                                Text("\(item.trees) trees").font(.caption2)
                            }
                        }
                    }
                }
            }.frame(width: 300, height: 250).background()
            
            List{
                Section("Report") {
                    HStack{
                        //Label("Average", systemImage: "calendar.day.timeline.left")
                        Text("Average")
                        Spacer()
                        Text("\(averageVal) trees / day")
                    }
                    HStack{
                        //Label("Block Record", systemImage: "arrow.up")
                        Text("Block Record")
                        Spacer()
                        Text("\(maxVal) trees")
                    }
                    HStack{
                        //Label("Block Total", systemImage: "sum")
                        Text("Block Total")
                        Spacer()
                        Text("\(total) trees")
                    }
                }
            }.frame(height: 200)
        }.navigationTitle("Planter Progress")
        .onAppear(){
            peopleList = personStore.getCrew() // initials here
            selectedPerson = peopleList[0]
            updateTreesPerDayData()
        }
    }
}

struct PlanterProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterProgressView(block: .constant(Block.sampleData[0])).environmentObject(TallyStore()).environmentObject(PersonStore())
    }
}

struct TreesPerDay: Identifiable {
    var day: String
    var trees: Double
    var id = UUID()
}
