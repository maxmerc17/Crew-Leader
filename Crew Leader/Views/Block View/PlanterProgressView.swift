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
        Form {
            Section(""){
                HStack {
                    Label("Planter", systemImage: "person")
                    Spacer()
                    Picker("", selection: $selectedPerson){
                        ForEach(peopleList){ member in
                            Text("\(member.fullName)").tag(member)
                        }
                    }.onChange(of: selectedPerson){ val in
                        print(val)
                        updateTreesPerDayData()
                    }
                }
            }
            Section("") {
                HStack{
                    Label("Total Planted", systemImage: "sum")
                    Spacer()
                    Text("\(total)")
                }
                HStack{
                    Label("Most Planted", systemImage: "arrow.up")
                    Spacer()
                    Text("\(maxVal)")
                }
                HStack{
                    Label("Average", systemImage: "calendar.day.timeline.left")
                    Spacer()
                    Text("\(averageVal)")
                }
            }
            Section(""){
                VStack {
                    Text("Trees Per Day").font(.title3).padding()
                    Chart{
                        ForEach(treesPerDayData, id: \.day){ item in
                            BarMark(
                                x: .value("Day", item.day),
                                y: .value("Trees Planted", item.trees)
                            ).annotation{
                                Text("\(item.trees) trees")
                            }
                        }
                    }.frame(height: 200)
                }.padding().background(.regularMaterial)
            }
        }.navigationTitle("Planter Progress")
        .onAppear(){
            peopleList = personStore.getCrew()
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
