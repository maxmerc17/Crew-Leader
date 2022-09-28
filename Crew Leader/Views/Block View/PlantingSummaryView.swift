//
//  PlantingSummaryView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-19.
//

import SwiftUI

struct PlantingSummaryView: View {
    @State var block: Block
    //@State var cutsArray: [(Species, String, Int, Int)] = []
    
    //@State var displayingTrees = true
    
//    func updateCutsArray()  {
//        var tempArray : [(Species, String, Int)] = block.getCutsPerPlantingUnit()
//
//        // adding a key so it is readable in the front end
//        var count = 0
//        cutsArray = tempArray.map{ elem in count+=1; return (elem.0, elem.1, elem.2, count);  }
//    }
//
//    func unitNum_text(_ plantingUnit: PlantingUnit) -> Int {
//        return block.getUnitNumber(plantingUnit)! // !!
//    }
    
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
            
            PlantingUnitsView(block: block)
            
            Section("Boxes to bring to the block"){
                ForEach(block.getBoxesToBringPerSpecies(), id: \.species){ elem in
                    HStack{
                        Text(elem.species.name)
                        Spacer()
                        Text("\(elem.boxesToBring) boxes")
                    }
                }
            }
            
//            Section("Species and Mix"){
//                if (cutsArray.isEmpty){
//                    Text("No species added").foregroundColor(.gray)
//                }
//                else{
//                    ForEach(cutsArray, id: \.3) { item in
//                        DisplayRowItem5(species: item.0, mix: item.1, plantingUnit: item.2, displayingTrees: $displayingTrees)
//                    }
//                }
//            }
        }.onAppear(){
            //updateCutsArray()
        }.navigationTitle("Planting Summary")
    }
}

struct PlantingUnitsView : View {
    @State var block : Block
    var body: some View {
        Section("Planting Units"){
            if (block.plantingUnits.isEmpty){
                Text("No planting units added").foregroundColor(.gray)
            }
            else{
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
    }
}

struct DisplayRowItem4: View {
    @State var plantingUnit : PlantingUnit
    var body: some View {
        HStack{
            Text("\(utilities.formatFloat(float: plantingUnit.area)) ha").bold()
            Spacer()
            Text("\(plantingUnit.density) trees / ha").bold()
            Spacer()
            Text("\(plantingUnit.TreesPU) trees").bold()
        }
    }
}

struct DisplayRowItem5: View {
    @State var species : Species
    @State var mix : String
    @State var plantingUnit : Int
    @Binding var displayingTrees : Bool
    
    var body: some View {
        HStack{
            //Label("\(species.name)", systemImage: "leaf")
            Text("\(species.name)")
            Spacer()
            Text("Unit \(plantingUnit)")
            Spacer()
            Text("\(mix)%")
            Spacer()
            
        }
    }
}

struct PlantingSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PlantingSummaryView(block: Block.sampleData[0])
    }
}
