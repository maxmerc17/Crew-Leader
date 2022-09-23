//
//  ImportPlantingUnitView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-23.
//

import SwiftUI

struct ImportPlantingUnitView: View {
    @Binding var selectedPlantingUnit : PlantingUnit
    
    @State var plantingUnits : [(plantingUnit: PlantingUnit, block: String, id : Int)] = []
    
    @State var noDataToView : Bool = false
    
    @EnvironmentObject var blockStore : BlockStore
    
    func load() {
        plantingUnits = blockStore.getAllPlantingUnits()
        if plantingUnits.isEmpty {
            noDataToView = true
        } else if selectedPlantingUnit.cuts.isEmpty {
            selectedPlantingUnit = plantingUnits[0].plantingUnit
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if noDataToView {
                VStack{
                    Text("There are currently no planting units created.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                    Text("Create a planting unit.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                }.padding()
                Button(action: load){
                    Label("Reload", systemImage: "arrow.clockwise")
                }
            } else {
                Text("Import a Planting Unit").font(.title).padding()
                List {
                    ForEach(plantingUnits, id: \.id) { unitBlockPair in
                        Button( action: { selectedPlantingUnit = unitBlockPair.plantingUnit } ){
                            VStack(alignment: .leading) {
                                Text(unitBlockPair.block).font(.headline).padding()
                                ForEach(unitBlockPair.plantingUnit.cuts) { cut in
                                    HStack{
                                        Text(cut.species.name)
                                        Spacer()
                                        Text("\(cut.species.treesPerBox) trees / box")
                                        Spacer()
                                        Text("\(cut.percent)%")
                                    }
                                }
                            }
                        }.buttonStyle(.plain).padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: selectedPlantingUnit == unitBlockPair.plantingUnit ? 2 : 0)
                        )
                    }
                }
            }
        }.onAppear(){
            load()
        }
    }
}

struct ImportPlantingUnitView_Previews: PreviewProvider {
    static var previews: some View {
        ImportPlantingUnitView(selectedPlantingUnit: .constant(PlantingUnit.init(data: PlantingUnit.Data())))
    }
}
