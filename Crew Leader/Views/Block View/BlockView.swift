//
//  BlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct BlockView: View {
    @Binding var block : Block
    @Binding var selectedCategory : String
    
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 100, slices: [], title: "Trees Per Planter", dataType: "trees", total: 0)
    
    @State var categories : [String] = ["Crew", "Species", "Date"]
    
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func categoryChanged(_ newCategory: String) {
        selectedCategory = newCategory
        switch newCategory {
            case "Crew": updateParametersWithCrew()
            case "Species": updateParametersWithSpecies()
            case "Date" : updateParametersWithDate()
            default: print("error") // should do something more here -- this point should not be reached
        }
    }
    
    func updateParametersWithCrew() {
        let crewPlantedDict = tallyStore.getTreesPerCrewMember(block: block.blockNumber)
        let sortedDict = crewPlantedDict.sorted(by: { $0.value > $1.value })
        let totalPlanted = sortedDict.reduce(0){ currTotal, item in
            currTotal + item.value
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var pieSlicesData : [Slice] = []
        for item in sortedDict {
            let newSlice = Slice(name: item.key, value: item.value, total: block.totalAlloction, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
        pieChartParameters.total = block.totalAlloction
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    func updateParametersWithSpecies() {
        
    }
    func updateParametersWithDate() {
        
    }
    
    var body: some View {
        VStack {
            PieChartView(pieChartParameters: $pieChartParameters).frame(width: 400, height: 220)
            
            HStack(spacing: 25) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        categoryChanged(category)
                        
                    } label: {
                        HStack {
                            Text("\(category)")
                        }.font(.system(size: 15))
                            .foregroundColor(category == selectedCategory
                                ? .accentColor
                                : .gray)
                    }
                }
            }.padding()
            List{
                NavigationLink(destination: PlantingSummaryView(block: block)){
                    Text("Planting Summary")
                }
            }
        }.navigationTitle("\(block.blockNumber)")
            .onAppear(){
                categoryChanged(selectedCategory)
            }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: .constant(Block.sampleData[0]), selectedCategory: .constant("Crew")).environmentObject(TallyStore())
    }
}
