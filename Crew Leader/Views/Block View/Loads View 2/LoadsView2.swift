//
//  LoadsView2.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-27.
//


import SwiftUI

struct LoadsView2: View {
    @Binding var block : Block
    
    @State var isPresentingAddLoadView : Bool = false
    
    @EnvironmentObject var speciesStore : SpeciesStore
    
    var blockLoads : [Load] {
        return block.loads.sorted(by: { $0.date > $1.date } )
    }
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var body: some View {
        GeometryReader { g in
            ScrollView{
                ChartView4_2(block: block).frame(width: g.size.width*0.95, height: g.size.height*0.4)
                ProgressSectionView2(block: block)
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
                }.frame(height: CGFloat(Int(minRowHeight)*blockLoads.count + 100) ).scrollDisabled(true)
            }
        }
        .navigationTitle("Loads")
        .sheet(isPresented: $isPresentingAddLoadView) {
            NavigationView {
                //AddLoadView(block: block, isPresentingAddLoadView: $isPresentingAddLoadView, selectedSpecies: selectedSpecies, selectedSpecies2: selectedSpecies) // FOD
            }
        }
    }
}

struct ProgressSectionView2 : View {
    @State var block : Block
    
    @State var isShowingByBoxes : Bool = true
    
    func boxesToGet(plantingUnit: PlantingUnit, species: Species) -> Int {
        let cacheCalculator : CacheCalculator = CacheCalculator(desiredTrees: plantingUnit.TreesPU, cuts: plantingUnit.cuts)
        let boxesPerSpecies = cacheCalculator.calculateBoxesPerSpecies()
        return boxesPerSpecies.first(where: { $0.0 == species })?.1 ?? 0 // ????
    }
    
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
        let extra = 50
        let progressHeight = block.plantingUnits.reduce(0) { tot, elem in
            tot + (elem.cuts.count)*60
        }
        
        return CGFloat(extra + progressHeight)
    }
    
    var body: some View {
        VStack(alignment: .center){
            Form{
                Section("Net Progress - Includes all pickups and returns."){
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
}

import Charts

struct ChartView4_2 : View {
    @State var block : Block
    
    @State var loadsData :  [(day: String, species: Species, boxes: Int)]  = []
    @State var noDataToView : Bool = false
    
    func updateLoadData() {
        
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
                            y: .value("Boxes", elem.boxes)
                        ).annotation{
                            Text("\(elem.boxes) Boxes").font(.caption2)
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


//struct Loads2View_Previews: PreviewProvider {
//    static var previews: some View {
//        Loads2View(block: .constant(Block.sampleData[0]))
//    }
//}

