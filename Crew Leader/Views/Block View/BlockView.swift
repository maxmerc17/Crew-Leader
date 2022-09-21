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
    
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 100, slices: [], title: "", dataType: "trees", total: 0)
    @State var selectedSlice : Slice? = nil
    
    @State var additionalDetails : String = ""
    
    @State var categories : [String] = ["Progress", "Species", "Date"]
    
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    func categoryChanged(_ newCategory: String) {
        selectedCategory = newCategory
        switch newCategory {
            case "Progress": updateParametersWithProgress()
            case "Species": updateParametersWithSpecies()
            case "Date" : updateParametersWithDate()
            default: print("error") // should do something more here -- this point should not be reached
        }
    }
    
    func updateParametersWithProgress() {
        let crewPlantedDict = tallyStore.getTreesPerCrewMember(block: block.blockNumber)
        let sortedDict = crewPlantedDict.sorted(by: { $0.value > $1.value })
        let totalPlanted = sortedDict.reduce(0){ currTotal, item in
            currTotal + item.value
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var pieSlicesData : [Slice] = []
        for item in sortedDict {
            let newSlice = Slice(name: personStore.getPlanter(id: item.key)!.fullName, value: item.value, total: block.totalAlloction, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
        additionalDetails = "\(utilities.formatInteger(totalPlanted)) / \(utilities.formatInteger(block.totalAlloction)) trees planted"
        selectedSlice = nil
        pieChartParameters.total = block.totalAlloction
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    func updateParametersWithSpecies() {
        let speciesPlantedDict = tallyStore.getTreesPerSpecies(block: block.blockNumber)
        let sortedDict = speciesPlantedDict.sorted(by: { $0.value > $1.value })
        let totalPlanted = sortedDict.reduce(0){ currTotal, item in
            currTotal + item.value
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var pieSlicesData : [Slice] = []
        for item in sortedDict {
            let newSlice = Slice(name: item.key, value: item.value, total: totalPlanted, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
        additionalDetails = " "
        selectedSlice = nil
        pieChartParameters.total = totalPlanted
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    func updateParametersWithDate() {
        let treesPerDate = tallyStore.getTreesPerDate(block: block.blockNumber)
        let totalPlanted = treesPerDate.reduce(0){ currTotal, item in
            currTotal + item.trees
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var pieSlicesData : [Slice] = []
        for item in treesPerDate {
            let newSlice = Slice(name: item.day, value: item.trees, total: totalPlanted, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
        additionalDetails = "Average of \(utilities.formatInteger(tallyStore.getAverageTreesPerDay(block: block.blockNumber))) trees per day"
        selectedSlice = nil
        pieChartParameters.total = totalPlanted
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    
    var body: some View {
        VStack {
            PieChartView(pieChartParameters: $pieChartParameters, selectedSlice: $selectedSlice).frame(width: 400, height: 220)
            
            Text(additionalDetails).font(.caption)
            
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
                Section(""){
                    HStack{
                        Label("Total trees planted", systemImage: "sum")
                        Spacer()
                        Text(utilities.formatInteger(tallyStore.getTotalTreesPlanted(block: block.blockNumber)))
                    }
                    HStack{
                        Label("Average", systemImage: "calendar.day.timeline.left")
                        Spacer()
                        Text(utilities.formatInteger(tallyStore.getAverageTreesPerDay(block: block.blockNumber)))
                    }
                }
                NavigationLink(destination: PlantingSummaryView(block: block)){
                    Text("Planting Summary")
                }
                NavigationLink(destination: PlanterProgressView(block: $block)){
                    Text("Planter Progress")
                }
                NavigationLink(destination: BlockProgressView(block: $block)){
                    Text("Block Progress")
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
        BlockView(block: .constant(Block.sampleData[0]), selectedCategory: .constant("Progress")).environmentObject(TallyStore())
    }
}
