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
            ChartView3(block: block).frame(width: 350, height: 270)
            
            List{
                Section("Report"){
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
                
                Section("Data"){
                    NavigationLink(destination: {}){
                        Label("Loads", systemImage: "box.truck")
                    }
                    NavigationLink(destination: {}){
                        Label("Plots", systemImage: "mappin.and.ellipse")
                    }
                }
            }.scrollDisabled(true).frame(height: 400)
            
            PieChartHeaderView(block: $block, selectedCategory: $selectedCategory).frame(width: 350, height: 270)
            
            List{
                Section("Reports"){
                    NavigationLink(destination: PlantingSummaryView(block: block)){
                        //Text("Planting Summary")
                        Label("Planting Summary", systemImage: "doc.plaintext.fill")
                    }
                    NavigationLink(destination: PlanterProgressView(block: $block)){
                        //Text("Planter Reports")
                        Label("Planter Reports", systemImage: "doc.on.doc")
                    }
//                    NavigationLink(destination: BlockProgressView(block: $block)){
//                        //Text("Block Report")
//                        Label("Block Report", systemImage: "doc")
//                    }
                }
            }.scrollDisabled(true).frame(height: 250)
            
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
            }
            
            switch selectedCategory {
                case "Progress": ProgressChartView(block: block)
                case "Species": SpeciesChartView(block: block)
                    //case "Date" : updateParametersWithDate()
                    default: Text("") // should do something more here -- this point should not be reached
            }
        }.padding()
        
    }
}

struct ProgressChartView : View {
    @State var block : Block
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 90, slices: [], title: "", dataType: "trees", total: 0)
    @State var selectedSlice : Slice? = nil
    
    @EnvironmentObject var tallyStore : TallyStore
    @EnvironmentObject var personStore : PersonStore
    
    func updateParameters() {
        let blockTotal = tallyStore.getTotalTreesPlanted(block: block.blockNumber)
        
        var total = 0
        if blockTotal > block.totalAlloction{
            total = blockTotal
        } else {
            total = block.totalAlloction
        }
        
        var pieSlicesData : [Slice] = []
        
        pieSlicesData.append(Slice(name: "Planted", value: blockTotal, total: total, color: .red))
        if blockTotal < block.totalAlloction {
            let value = block.totalAlloction-blockTotal-1
            pieSlicesData.append(Slice(name: "Remaining", value: value, total: total, color: .blue))
        }
        
        selectedSlice = nil
        pieChartParameters.total = total
        pieChartParameters.title = "Total Planted: \(utilities.formatInteger(total))"
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
                Text("")
                PieChartView(pieChartParameters: $pieChartParameters, selectedSlice: $selectedSlice)
            }
        }.frame(width: 350, height: 240)
        .onAppear(){
            updateParameters()
        }
    }
}

struct SpeciesChartView : View {
    @State var block : Block
    @State var pieChartParameters : PieChartParameters = PieChartParameters(radius: 90, slices: [], title: "", dataType: "trees", total: 0)
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
                //Text("Total Trees Planted Per Species on \(block.blockNumber)").multilineTextAlignment(.center)
                Text("")
                PieChartView(pieChartParameters: $pieChartParameters, selectedSlice: $selectedSlice)
            }
        }.frame(width: 350, height: 240)
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
