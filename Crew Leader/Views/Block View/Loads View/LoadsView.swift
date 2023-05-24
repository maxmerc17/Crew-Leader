//
//  LoadsView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-23.
//

import SwiftUI

struct LoadsView: View {
    @Binding var block : Block
    
    @State var isPresentingAddLoadView : Bool = false
    
    @EnvironmentObject var speciesStore : SpeciesStore
    
    var body: some View {
        GeometryReader { g in
            ScrollView{
                PlantingUnitsDropDownView(block: block)
                ProgressSectionView(block: block)
                ChartHeader(block: block)
                PastLoadsList(block: block)
            }.navigationTitle("Loads")
            .toolbar {
                NavigationLink(destination: AddLoadView(block: block,
                                                        isPresentingAddLoadView: $isPresentingAddLoadView )) {
                    Image(systemName: "plus")
                }
            }
        }
        
    }
}

//            .sheet(isPresented: $isPresentingAddLoadView) {
//                NavigationView {
//                    AddLoadView(block: block, isPresentingAddLoadView: $isPresentingAddLoadView, selectedSpecies: selectedSpecies, selectedSpecies2: selectedSpecies) // FOD
//                }
//            }

struct PlantingUnitsDropDownView : View {
    @State var block: Block
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    @State var isViewingPlantingUnits : Bool = false
    
    var frameHeight : CGFloat {
        let extra = 50 + Int(minRowHeight)
        let cutsHeight = block.plantingUnits.reduce(0) { tot, elem in
            tot + (elem.cuts.count)*Int(minRowHeight)
        }
        let plantingUnitHeight = block.plantingUnits.count * Int(minRowHeight)
        
        return isViewingPlantingUnits ? CGFloat(extra + cutsHeight + plantingUnitHeight) :  CGFloat(extra)
    }
    
    
    var body: some View {
        Form {
            Section("Planting Units"){
                HStack {
                    Text("View Planting Units")
                    Spacer()
                    isViewingPlantingUnits ? Image(systemName: "chevron.down.circle") : Image(systemName: "chevron.right.circle")
                }.foregroundColor(.blue)
                .onTapGesture {
                    isViewingPlantingUnits = !isViewingPlantingUnits
                }
                
                if isViewingPlantingUnits {
                    ForEach(block.plantingUnits) { plantingUnit in
                        DisplayRowItem4(plantingUnit: plantingUnit)
                        ForEach(plantingUnit.cuts) { cut in
                            HStack{
                                Text("\(cut.species.name)")
                                Spacer()
                                Text("\(cut.percent)%")
                                Spacer()
                                Text("\(cut.numTrees(plantingUnit.TreesPU)) trees")
                                Spacer()
                                Text("\(cut.numBoxes(plantingUnit.TreesPU)) boxes")
                            }
                        }
                    }
                }
            }
        }.frame(height: frameHeight)
    }
}

struct ProgressSectionView : View {
    @State var block : Block
    
    @State var isShowingByBoxes : Bool = true
    
    func boxesToGet(plantingUnit: PlantingUnit, species: Species) -> Int {
        let cacheCalculator : CacheCalculator = CacheCalculator(desiredTrees: plantingUnit.TreesPU, cuts: plantingUnit.cuts)
        let boxesPerSpecies = cacheCalculator.calculateBoxesPerSpecies()
        return boxesPerSpecies.first(where: { $0.0 == species })?.1 ?? 0 // ????
    }
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    /// this is poorly written
    var ProgressRowData : [(species: Species, taken: Int, toGet: Int)] {
        var returnArray : [(species: Species, taken: Int, toGet: Int)] = []
        
        for plantingUnit in block.plantingUnits {
            for cut in plantingUnit.cuts {
                let toGet = boxesToGet(plantingUnit: plantingUnit, species: cut.species)
                if let i = returnArray.firstIndex(where: { $0.species == cut.species }){
                    returnArray[i].taken = returnArray[i].taken + block.getBoxesPerSpeciesTaken(species: cut.species)
                    returnArray[i].toGet = returnArray[i].toGet + toGet
                } else {
                    returnArray.append((species: cut.species, taken: block.getBoxesPerSpeciesTaken(species: cut.species), toGet: toGet))
                }
            }
        }
        
        var newArray : [(species: Species, taken: Int, toGet: Int)] = []
        for load in block.loads {
            for bps in load.boxesPerSpeciesTaken {
                if !returnArray.contains(where: { $0.species == bps.key } ) {
                    if let i = newArray.firstIndex(where: { $0.species == bps.key }){
                        newArray[i].taken = newArray[i].taken + block.getBoxesPerSpeciesTaken(species: bps.key)
                    } else {
                        newArray.append((species: bps.key, taken: block.getBoxesPerSpeciesTaken(species: bps.key), toGet: 0))
                    }
                }
            }
        }
        
        returnArray = returnArray + newArray
        return returnArray
    }
    
    var ProgressRowDataByTrees : [(species: Species, taken: Int, toGet: Int)]{
        ProgressRowData.map { elem in (species: elem.species, taken: elem.taken*elem.species.treesPerBox, toGet: elem.toGet*elem.species.treesPerBox) }
    }
    
    var frameHeight : CGFloat {
        let extra = 80
        let progressHeight = block.plantingUnits.reduce(0) { tot, elem in
            tot + (elem.cuts.count)*Int(minRowHeight)
        }
        
        return CGFloat(extra + progressHeight)
    }
    
    var body: some View {
        Form{
            Section("Progress"){
                isShowingByBoxes
                ?
                    ForEach(ProgressRowData, id: \.species) { row in
                        HStack{
                            Text("\(row.species.name)")
                            Spacer()
                            row.toGet == 0 ? Text("\(row.taken) boxes taken") : Text("\(row.taken) / \(row.toGet) boxes taken")
                        }
                    }
                :
                    ForEach(ProgressRowDataByTrees, id: \.species) { row in
                        HStack{
                            Text("\(row.species.name)")
                            Spacer()
                            row.toGet == 0 ? Text("\(row.taken) trees taken") : Text("\(row.taken) / \(row.toGet) trees taken")
                        }
                    }
                Text("Tap form to see progress by trees or by boxes.").font(.caption2)
            }
        }
        .frame(height: frameHeight)
        .scrollDisabled(true)
        .onTapGesture {
            isShowingByBoxes = !isShowingByBoxes
        }
    }
}

struct ChartHeader : View {
    @State var block : Block
    
    var listOfCharts = ["Total Boxes", "Boxes Per Species"]
    @State var chart_selected : String = "Boxes Per Species"
    
    var body: some View {
        VStack{
            VStack{
                switch chart_selected {
                    case "Boxes Per Species": Text("Boxes per species")
                    case "Total Boxes": BoxesPerDayChart(block: block)
                    default: Text("Error displaying chart.")
                }
            }.frame(width: 350, height: 270)
            HStack (spacing: 25){
                ForEach(listOfCharts, id: \.self) { chart in
                    Button(action: { chart_selected = chart }) {
                        Text(chart).font(.system(size: 15)).foregroundColor( chart_selected == chart ? .accentColor : .gray)
                    }
                }
            }
        }
        
    }
}

import Charts
struct BoxesPerDayChart : View {
    @State var block : Block
    
    @State var loadsData :  [(day: String, boxesTaken: Int, boxesReturned: Int)]  = []
    @State var noDataToView : Bool = false
    
    func updateLoadData() {
        loadsData = block.getLoadsData()
        if loadsData.isEmpty{
            noDataToView = true
        }
    }
    
    
    var body: some View {
        VStack {
            if loadsData.isEmpty{
                if (noDataToView) {
                    VStack{
                        Text("There is currently no load data to view.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                        Text("Add a load to this block.").font(.caption).foregroundColor(.gray)
                    }.padding()
                }
                Button(action: updateLoadData){
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            } else {
                Text("Loads for \(block.blockNumber)").font(.title3).padding().multilineTextAlignment(.center)
                Chart{
                    ForEach(loadsData, id: \.day){ elem in
                        BarMark(
                            x: .value("Day", elem.day),
                            y: .value("Boxes", elem.boxesTaken)
                        ).annotation{
                            Text("\(elem.boxesTaken) Boxes").font(.caption2)
                        }
                    }
                }
            }
        }.padding()
        .onAppear(){
            updateLoadData()
        }
    }
}

struct PastLoadsList : View {
    @State var block : Block
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var blockLoads : [Load] {
        return block.loads.sorted(by: { $0.date > $1.date } )
    }
    
    var frameHeight : CGFloat {
        let extraHeight = 120
        let pastLoadsHeight = blockLoads.count*Int(minRowHeight)
        return CGFloat( extraHeight + pastLoadsHeight )
    }
    var body: some View {
        List {
            Section("Past Loads"){
                if blockLoads.isEmpty {
                    Text("No loads completed.").foregroundColor(.gray)
                } else {
                    ForEach(blockLoads) { load in
                        NavigationLink(destination: {}){
                            HStack{
                                Text( utilities.formatDate(date: load.date) )
                                Spacer()
                                Text("\(load.boxesTaken) boxes")
                            }
                        }
                    }
                }
            }
        }.frame(height: frameHeight ).scrollDisabled(true)
    }
}




struct LoadsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadsView(block: .constant(Block.sampleData[0]))
    }
}
