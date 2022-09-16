//
//  CreateBlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

import SwiftUI

struct CreateBlockView: View {
    @Binding var newBlockData : Block.Data
    
    @State var selectedSpecies = Species.sampleData[0]
    @State var mix = ""
    @State var selectedPlantingUnit = 1
    
    
    @State var cutsArray : [(Species, String, Int)] = []
    
    @State var plantingUnits : [PlantingUnit] = []
    @State var selectedBlockArea : String = ""
    @State var selectedDensity : Int = 1400
    @State var selectedTreesPU : String = ""
    
    @Binding var isShowingAlert : Bool //= false
    @Binding var alertText : alertTextType //= alertTextType()
    
    func addPlantingUnit() {
        if selectedBlockArea == ""{
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for area."
            isShowingAlert = true
            return
        }
        if selectedTreesPU == ""{
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for trees / unit."
            isShowingAlert = true
            return
        }
        
        
        let newPlantingUnit = PlantingUnit(area: Float(selectedBlockArea)!, density: selectedDensity, TreesPU: Int(selectedTreesPU)!)
        plantingUnits.append(newPlantingUnit)
    }
    
    func addSpecies() {
        if selectedPlantingUnit > plantingUnits.count {
            alertText.title = "Improper Input"
            alertText.message = "Selected planting unit does not exist. Select a planting unit which does exist or create a new planting unit."
            isShowingAlert = true
            return
        }
        if mix.isEmpty{
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for mix."
            isShowingAlert = true
            return
        }
        if  !mix.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Mix value should be an integer between 0 and 100."
            isShowingAlert = true
            return
        }
        if Int(mix)! > 100 {
            alertText.title = "Improper Input"
            alertText.message = "Mix value should be less than 100."
            isShowingAlert = true
            return
        }
        if Int(mix)! < 0 {
            alertText.title = "Improper Input"
            alertText.message = "Mix value should be greater than 0."
            isShowingAlert = true
            return
        }
        if Int(mix)! == 0 {
            alertText.title = "Improper Input"
            alertText.message = "Mix value cannot be 0."
            isShowingAlert = true
            return
        }
        
        let speciesInList : [Species] = cutsArray.map {$0.0}
        if speciesInList.contains(selectedSpecies){
            alertText.title = "Improper Input"
            alertText.message = "Selected species has already been added to the list. Please select a different species."
            isShowingAlert = true
            return
        }
        
        cutsArray.append((selectedSpecies, mix, selectedPlantingUnit))
    }
    
    var body: some View {
        Form{
            Section(""){
                HStack{
                    Label("Block Name: ", systemImage: "textformat")
                    Spacer()
                    TextField("ex. BUCK0059", text: $newBlockData.blockNumber).multilineTextAlignment(.trailing)
                }
                HStack{
                    Label("Start Date", systemImage: "calendar")
                    Spacer()
                    DatePicker(selection: $newBlockData.blockDetails.workStartDate, displayedComponents: .date, label: { Text("")})
                }
            }
            
            Section("Planting Units"){
                if (plantingUnits.isEmpty){
                    Text("Add planting units to this block").foregroundColor(.gray)
                }
                else{
                    ForEach($plantingUnits) { $item in
                        DisplayRowItem3(plantingUnit: $item, plantingUnits: $plantingUnits)
                    }
                }
            }
            
            Section("Add Planting Unit"){
                HStack {
                    Label("Area", systemImage: "skew")
                    TextField("ex. 27.1", text: $selectedBlockArea).multilineTextAlignment(.trailing).keyboardType(.numberPad)
                }
                HStack {
                    Label("Density", systemImage: "circle.hexagongrid")
                    Picker("", selection: $selectedDensity){
                        Text("1200").tag(1200)
                        Text("1400").tag(1400)
                    }
                }
                HStack{
                    Label("Trees / Unit", systemImage: "leaf")
                    TextField("ex. 38000", text: $selectedTreesPU).multilineTextAlignment(.trailing).keyboardType(.numberPad)
                }
                HStack {
                    Spacer()
                    Button(action: addPlantingUnit){
                        Text("Add")
                    }
                    Spacer()
                }
                
                
            }
            Section("Species and Mix"){
                if (cutsArray.isEmpty){
                    Text("Add species to this block").foregroundColor(.gray)
                }
                else{
                    ForEach($cutsArray, id: \.0) { $item in
                        DisplayRowItem2(species: $item.0, mix: $item.1, inputArray: $cutsArray, selectedPlantingUnit: $selectedPlantingUnit)
                    }
                }
                
            }
            Section("Add Species"){
                HStack {
                    Label("Planting Unit", systemImage: "number")
                    Picker("", selection: $selectedPlantingUnit){
                        ForEach(1..<6)
                        { unit in
                            Text("\(unit)").tag(unit)
                        }
                    }
                }
                HStack {
                    Label("Species", systemImage: "leaf")
                    Picker("", selection: $selectedSpecies){
                        ForEach(Species.sampleData){ species in
                            Text("\(species.name)").tag(species)
                        }
                    }
                }
                HStack{
                    Label("Mix", systemImage: "percent")
                    TextField("ex. 67", text: $mix).multilineTextAlignment(.trailing).keyboardType(.numberPad)
                    Text("%")
                }
                HStack {
                    Spacer()
                    Button(action: addSpecies){
                        Text("Add")
                    }
                    Spacer()
                }
            }
            
        }.alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("\(alertText.title)"),
                message: Text("\(alertText.message)")
            )
        }
    }
}

struct DisplayRowItem2: View {
    @Binding var species : Species
    @Binding var mix : String
    @Binding var inputArray : [(Species, String, Int)]
    @Binding var selectedPlantingUnit : Int
    
    @State var isShowingAlert = false
    
    func removeItem(){
        let index = inputArray.firstIndex {$0 == (species, mix, selectedPlantingUnit)}!
        inputArray.remove(at: index)
    }
    
    var body: some View {
        HStack{
            Label("\(species.name)", systemImage: "leaf")
            Spacer()
            Text("Unit \(selectedPlantingUnit)")
            Spacer()
            Text("\(mix)%")
            Spacer()
            Button(action: removeItem){
                Image(systemName: "minus.circle")
            }.help("Remove Item")
        }
    }
}

struct DisplayRowItem3: View {
    @Binding var plantingUnit : PlantingUnit
    @Binding var plantingUnits : [PlantingUnit]
    
    @State var isShowingAlert = false
    
    func removeItem(){
        let index = plantingUnits.firstIndex {$0 == plantingUnit}!
        plantingUnits.remove(at: index)
    }
    
    var body: some View {
        HStack{
            Text("\(utilities.formatFloat(float: plantingUnit.area)) ha")
            Spacer()
            Text("\(plantingUnit.density) trees / ha")
            Spacer()
            Text("\(plantingUnit.TreesPU) trees")
            Spacer()
            Button(action: removeItem){
                Image(systemName: "minus.circle")
            }.help("Remove Item")
        }
    }
}

struct CreateBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBlockView(newBlockData: .constant(Block.Data()), isShowingAlert: .constant(false), alertText: .constant(alertTextType()))
    }
}
