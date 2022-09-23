//
//  PlantingSummaryView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-19.
//

import SwiftUI

struct PlantingSummaryView: View {
    @State var block: Block
    @State var cutsArray: [(Species, String, Int, Int)] = []
    
    func updateCutsArray()  {
        var array : [(Species, String, Int, Int)] = []
        
        var key : Int = 1
        var unitNumber = 1
        for plantingUnit in block.plantingUnits {
            for cut in plantingUnit.cuts {
                array.append((cut.species, String(cut.percent), unitNumber, key))
                key+=1
            }
            unitNumber+=1
        }
        cutsArray = array
    }
    
    var body: some View {
        Form{
            Section("Static Data"){
                HStack{
                    //Label("Block Name ", systemImage: "textformat")
                    Text("Block Name")
                    Spacer()
                    Text(block.blockNumber).multilineTextAlignment(.trailing)
                }
                HStack{
                    //Label("Start Date", systemImage: "calendar")
                    Text("Start Date")
                    Spacer()
                    Text(utilities.formatDate(date: block.blockDetails.workStartDate))
                }
            }
            Section("Planting Units"){
                if (block.plantingUnits.isEmpty){
                    Text("No planting units added").foregroundColor(.gray)
                }
                else{
                    ForEach($block.plantingUnits) { $item in
                        DisplayRowItem4(plantingUnit: $item)
                    }
                }
            }
            
            Section("Species and Mix"){
                if (cutsArray.isEmpty){
                    Text("No species added").foregroundColor(.gray)
                }
                else{
                    ForEach(cutsArray, id: \.3) { item in
                        DisplayRowItem5(species: item.0, mix: item.1, plantingUnit: item.2)
                    }
                }
                
            }
        }.onAppear(){
            updateCutsArray()
        }.navigationTitle("Planting Summary")
    }
}

struct DisplayRowItem4: View {
    @Binding var plantingUnit : PlantingUnit
    var body: some View {
        HStack{
            Text("\(utilities.formatFloat(float: plantingUnit.area)) ha")
            Spacer()
            Text("\(plantingUnit.density) trees / ha")
            Spacer()
            Text("\(plantingUnit.TreesPU) trees")
        }
    }
}

struct DisplayRowItem5: View {
    @State var species : Species
    @State var mix : String
    @State var plantingUnit : Int
    
    
    var body: some View {
        HStack{
            //Label("\(species.name)", systemImage: "leaf")
            Text("\(species.name)")
            Spacer()
            Text("Unit \(plantingUnit)")
            Spacer()
            Text("\(mix)%")
            
        }
    }
}

struct PlantingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PlantingSummaryView(block: Block.sampleData[0])
    }
}
