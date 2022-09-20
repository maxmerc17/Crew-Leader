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
    @State var update = ""
    
    @State var centerTextTitle = "Trees Planted Per Crew Member"
    @State var pieSlices : [Slice] = []
    
    @State var categories : [String] = ["Crew", "Species", "Date"]
    
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func categoryChanged(_ newCategory: String) {
        selectedCategory = newCategory
        switch newCategory {
            case "Crew": updatePieSlicesWithCrew()
            case "Species": updatePieSlicesWithSpecies()
            case "Date" : updatePieSlicesWithDate()
            default: print("error") // should do something more here -- this point should not be reached
        }
    }
    
    func updatePieSlicesWithCrew() {
        let crewPlantedDict = tallyStore.getTreesPerCrewMember(block: block.blockNumber)
        let totalPlanted = crewPlantedDict.reduce(0){ currTotal, item in
            currTotal + item.value
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var pieSlicesData : [Slice] = []
        for item in crewPlantedDict {
            let newSlice = Slice(name: item.key, value: item.value, total: totalPlanted, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
        centerTextTitle = "Trees Planted Per Crew Member"
        pieSlices = pieSlicesData
        update = update + " "
    }
    func updatePieSlicesWithSpecies() {
        
    }
    func updatePieSlicesWithDate() {
        
    }
    
    
    
    var body: some View {
        VStack {
            PieChartView(radius: .constant(100), slices: $pieSlices, centerTextTitle: $centerTextTitle, dataType: .constant("trees"), update: $update)
            
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
