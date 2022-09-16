//
//  CreateBlockView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-16.
//

// TODO: (if have time) not sure if the way I am managing the data is the most efficient
// TODO: (if have time) add labels to elements in tuple -- make code more clear

import SwiftUI

struct CreateBlockView: View {
    @Binding var newBlockData : Block.Data
    @Binding var blocks : [Block]
    @Binding var isPresentingNewBlockView : Bool
    
    @State var selectedBlockArea : String = ""
    @State var selectedDensity : Int = 1400
    @State var selectedTreesPU : String = ""
    @State var plantingUnits : [PlantingUnit] = []
    
    @State var selectedSpecies = Species.sampleData[0]
    @State var mix = ""
    @State var selectedPlantingUnit = 1
    @State var cutsArray : [(Species, String, Int)] = [] // (selectedSpecies, mix, selectedPlantingUnit)
    
    @State var isShowingAlert : Bool = false
    @State var alertText = alertTextType()
    
    func Validate() -> Bool {
        if newBlockData.blockNumber == "" {
            alertText.title = "Improper Input"
            alertText.message = "Enter a Block name."
            isShowingAlert = true
            return false
        }
        if plantingUnits.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter one or more planting units."
            isShowingAlert = true
            return false
        }
        if cutsArray.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter one or more species for the block."
            isShowingAlert = true
            return false
        }
        
        for i in 0..<plantingUnits.count{
            let totalPercentage = cutsArray.reduce(0, {x, y in x + ((y.2 == i+1) ? Int(y.1)! : 0)})
            
            if totalPercentage != 100 {
                alertText.title = "Improper Input"
                alertText.message = "List of species for planting unit \(i+1) should sum to 100%. Add or remove species to ensure the planting unit mix is captured."
                isShowingAlert = true
                return false
            }
        }
        
        return true
    }
    
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
        
        let speciesInList : [Species] = cutsArray.filter { $0.2 == selectedPlantingUnit }.map { $0.0 }
        if speciesInList.contains(selectedSpecies){
            alertText.title = "Improper Input"
            alertText.message = "Selected species has already been added to the specified planting unit. Please select a different species."
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
                    Text("No planting units added").foregroundColor(.gray)
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
                    Text("No species added").foregroundColor(.gray)
                }
                else{
                    ForEach($cutsArray, id: \.0) { $item in
                        DisplayRowItem2(species: $item.0, mix: $item.1, inputArray: $cutsArray, selectedPlantingUnit: $item.2)
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
        .toolbar() {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    if Validate(){
                        for cut in cutsArray {
                            let newCut = Cut(species: cut.0, percent: Int(cut.1)!)
                            plantingUnits[(cut.2)-1].cuts.append(newCut)
                        }
                        
                        newBlockData.plantingUnits = plantingUnits
                        let newBlock = Block(data: newBlockData)
                        blocks.append(newBlock)
                        isPresentingNewBlockView = false
                        newBlockData = Block.Data()
                    }
                }
            }
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
        CreateBlockView(newBlockData: .constant(Block.Data()), blocks: .constant([]), isPresentingNewBlockView: .constant(true))
    }
}
