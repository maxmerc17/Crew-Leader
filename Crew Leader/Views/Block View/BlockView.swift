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
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    var body: some View {
        ScrollView {
            PieChartHeaderView(block: $block, selectedCategory: $selectedCategory).frame(width: 350, height: 270)
            
            Divider()
            
            ChartView3(block: block).frame(width: 350, height: 270)
            
            List{
                Section(""){
                    HStack{
                        Text("Planting Days")
                        Spacer()
                        Text("\(tallyStore.getTreesPerDate(block: block.blockNumber).count) days")
                    }
                    HStack{
                        //Label("Block Average", systemImage: "calendar.day.timeline.left")
                        Text("Block Average")
                        Spacer()
                        Text("\(utilities.formatInteger(tallyStore.getAverageTreesPerDay(block: block.blockNumber))) trees / day")
                    }
                    HStack{
                        Text("Block Record")
                        Spacer()
                        Text("\(tallyStore.getBlockRecord(block: block.blockNumber)) trees")
                    }
                    HStack{
                        //Label("Block Total", systemImage: "sum")
                        Text("Block Total")
                        Spacer()
                        Text("\(utilities.formatInteger(tallyStore.getTotalTreesPlanted(block: block.blockNumber))) trees")
                    }
                    
                }
                Section("Reports"){
                    NavigationLink(destination: PlantingSummaryView(block: block)){
                        //Text("Planting Summary")
                        Label("Planting Summary", systemImage: "doc.plaintext.fill")
                    }
                    NavigationLink(destination: PlanterProgressView(block: $block)){
                        //Text("Planter Reports")
                        Label("Planter Reports", systemImage: "doc.on.doc")
                    }
                    NavigationLink(destination: BlockProgressView(block: $block)){
                        //Text("Block Report")
                        Label("Block Report", systemImage: "doc")
                    }
                }
            }.scrollDisabled(true).frame(height: 500)
        }
        .navigationTitle("\(block.blockNumber)")
    }
}

struct PieChartHeaderView : View {
    @Binding var block : Block
    @Binding var selectedCategory : String
    
    @State var additionalDetails : String = ""
    
    @State var categories : [String] = ["Progress", "Species"] // removed date from options
    
    func categoryChanged(_ newCategory: String) {
        selectedCategory = newCategory
    }
    
    var body: some View{
        VStack{
            switch selectedCategory {
                case "Progress": ProgressChartView(block: block)
                case "Species": SpeciesChartView(block: block)
                    //case "Date" : updateParametersWithDate()
                    default: Text("") // should do something more here -- this point should not be reached
            }
            
            HStack(spacing: 25) {ForEach(categories, id: \.self) { category in
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
        }
        
    }
}

struct ProgressChartView : View {
    @State var block : Block
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 100, slices: [], title: "", dataType: "trees", total: 0)
    @State var selectedSlice : Slice? = nil
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    func updateParameters() {
        let crewPlantedDict = tallyStore.getTreesPerCrewMember(block: block.blockNumber)
        let sortedDict = crewPlantedDict.sorted(by: { $0.value > $1.value })
        let totalPlanted = sortedDict.reduce(0){ currTotal, item in
            currTotal + item.value
        }
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
        var colorIndex = 0
        
        var total = 0
        if totalPlanted > block.totalAlloction{
            total = totalPlanted
        } else {
            total = block.totalAlloction
        }
        
        var pieSlicesData : [Slice] = []
        for item in sortedDict {
            let newSlice = Slice(name: personStore.getPlanter(id: item.key)!.fullName, value: item.value, total: total, color: colors[colorIndex%colors.count])
            pieSlicesData.append(newSlice)
            colorIndex+=1
        }
        
//        additionalDetails = (totalPlanted > block.totalAlloction)
//        ? "\(utilities.formatInteger(totalPlanted-block.totalAlloction)) trees over allocation"
//        : "\(utilities.formatInteger(block.totalAlloction-totalPlanted)) trees under allocation"
        
        selectedSlice = nil
        pieChartParameters.total = total
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    
    var body : some View {
        VStack{
            if pieChartParameters.slices.isEmpty{
                Button(action: updateParameters){
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            } else {
                PieChartView(pieChartParameters: $pieChartParameters, selectedSlice: $selectedSlice)
            }
        }.frame(width: 350, height: 270)
        .onAppear(){
            updateParameters()
        }
    }
}

struct SpeciesChartView : View {
    @State var block : Block
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 100, slices: [], title: "", dataType: "trees", total: 0)
    @State var selectedSlice : Slice? = nil
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    func updateParameters() {
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
        
        //additionalDetails = " "
        selectedSlice = nil
        pieChartParameters.total = totalPlanted
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
        pieChartParameters.slices = pieSlicesData
        pieChartParameters.updateSliceHeaders()
    }
    
    var body: some View {
        VStack{
            if pieChartParameters.slices.isEmpty{
                Button(action: updateParameters){
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            } else {
                PieChartView(pieChartParameters: $pieChartParameters, selectedSlice: $selectedSlice)
            }
        }.frame(width: 350, height: 270)
        .onAppear(){
            updateParameters()
        }
    }
}


import Charts

struct ChartView3 : View {
    @State var block : Block
    
    @State var productionData : [(day: String, trees: Int)] = []
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateProductionData() {
        productionData = tallyStore.getTreesPerDate(block: block.blockNumber)
    }
    
    var body: some View {
        VStack {
            if productionData.isEmpty{
                Button(action: updateProductionData){
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            } else {
                Text("Crew's Daily Production for \(block.blockNumber)").font(.title3).padding().multilineTextAlignment(.center)
                Chart{
                    ForEach(productionData, id: \.day){ elem in
                        BarMark(
                            x: .value("Day", elem.day),
                            y: .value("Trees Planted", elem.trees)
                        ).annotation{
                            Text("\(elem.trees) trees").font(.caption2)
                        }
                    }
                }
            }
        }.padding()
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: .constant(Block.sampleData[0]), selectedCategory: .constant("Progress")).environmentObject(TallyStore())
    }
}

//
//func updateParametersWithDate() {
//    let treesPerDate = tallyStore.getTreesPerDate(block: block.blockNumber)
//    let totalPlanted = treesPerDate.reduce(0){ currTotal, item in
//        currTotal + item.trees
//    }
//
//    let colors: [Color] = [.red, .blue, .green, .yellow, .cyan, .indigo, .mint, .orange]
//    var colorIndex = 0
//
//    var pieSlicesData : [Slice] = []
//    for item in treesPerDate {
//        let newSlice = Slice(name: item.day, value: item.trees, total: totalPlanted, color: colors[colorIndex%colors.count])
//        pieSlicesData.append(newSlice)
//        colorIndex+=1
//    }
//
////        additionalDetails = "Average of \(utilities.formatInteger(tallyStore.getAverageTreesPerDay(block: block.blockNumber))) trees per day"
//    selectedSlice = nil
//    pieChartParameters.total = totalPlanted
//    pieChartParameters.title = "Total Planted: \(utilities.formatInteger(totalPlanted))"
//    pieChartParameters.slices = pieSlicesData
//    pieChartParameters.updateSliceHeaders()
//}
