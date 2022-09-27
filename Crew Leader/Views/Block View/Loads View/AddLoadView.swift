//
//  AddLoadView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-26.
//

import SwiftUI


struct AddLoadView: View {
    @State var block: Block
    @Binding var isPresentingAddLoadView : Bool
    
    @State var selectedDate : Date = Date.now
    @State var selectedSpecies : Species = Species(data: Species.Data()) // updateOnAppear, FOD
    @State var inputtedNumBoxes : String = ""
    @State var takeArray : [(species: Species, taken: Int)] = []
    var boxesTaken : Int {
        takeArray.reduce(0) { tot, elem in tot + elem.taken }
    }
    var treesTaken : Int {
        takeArray.reduce(0) { tot, elem in tot + elem.taken*elem.species.treesPerBox }
    }
    @State var displayTrees : Bool = false
    
    @State var selectedSpecies2 : Species = Species(data: Species.Data()) // updateOnAppear, FOD
    @State var inputtedNumBoxes2 : String = ""
    @State var returnArray : [(species: Species, returned: Int)] = []
    var boxesReturned : Int {
        returnArray.reduce(0) { tot, elem in tot + elem.returned }
    }
    var treesReturned : Int {
        returnArray.reduce(0) { tot, elem in tot + elem.returned*elem.species.treesPerBox }
    }
    @State var displayTrees2 : Bool = false
    
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @EnvironmentObject var speciesStore : SpeciesStore
    @EnvironmentObject var blockStore : BlockStore
    
    @State private var errorWrapper: ErrorWrapper?
    
    @State var requirementsNotMet : Bool = false
    
    func load() {
        if selectedSpecies2.name == "" { //!speciesStore.species.isEmpty && !blockStore.blocks.isEmpty {
            selectedSpecies = speciesStore.species[0]/// FOD
            selectedSpecies2 = speciesStore.species[0]
        } else {
            requirementsNotMet = true
        }
    }
    
    func Validate() -> Bool {
        if takeArray.isEmpty && returnArray.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Add at least one load."
            isShowingAlert = true
            return false
        }
        
        return true
    }
    
    func AddBoxesTaken() {
        if inputtedNumBoxes.isEmpty{
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for boxes."
            isShowingAlert = true
            return
        }
        if  !inputtedNumBoxes.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be an integer between 0 and 300."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes)! > 300 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be less than 300."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes)! < 0 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be greater than 0."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes)! == 0 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value cannot be 0."
            isShowingAlert = true
            return
        }
        let speciesInList : [Species] = takeArray.map {$0.0}
        
        if speciesInList.contains(selectedSpecies){
            alertText.title = "Improper Input"
            alertText.message = "Selected species has already been added to the list. Please select a different species."
            isShowingAlert = true
            return
        }
        
        takeArray.append((species: selectedSpecies, taken: Int(inputtedNumBoxes)!)) // !!
    }
    
    func AddBoxesReturned() {
        if inputtedNumBoxes2.isEmpty{
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for boxes."
            isShowingAlert = true
            return
        }
        if  !inputtedNumBoxes2.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be an integer between 0 and 300."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes2)! > 300 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be less than 300."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes2)! < 0 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value should be greater than 0."
            isShowingAlert = true
            return
        }
        if Int(inputtedNumBoxes2)! == 0 {
            alertText.title = "Improper Input"
            alertText.message = "Boxes value cannot be 0."
            isShowingAlert = true
            return
        }
        let speciesInList : [Species] = returnArray.map {$0.0}
        
        if speciesInList.contains(selectedSpecies2){
            alertText.title = "Improper Input"
            alertText.message = "Selected species has already been added to the list. Please select a different species."
            isShowingAlert = true
            return
        }
        
        returnArray.append((species: selectedSpecies2, returned: Int(inputtedNumBoxes2)!)) // !!
    }
    
    var body: some View {
        VStack {
            if (requirementsNotMet){
                VStack{
                    Text("Cannot load due to lack of species data.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                    Text("Species data may be taking longer to load. Or no species data exists.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                }.padding()
                Button(action: load){
                    Label("Reload", systemImage: "arrow.clockwise")
                }
            } else {
                Form {
                    Section(""){
                        HStack{
                            Label("Date", systemImage: "calendar")
                            Spacer()
                            DatePicker(selection: $selectedDate, displayedComponents: .date, label: { Text("")})
                        }
                    }
                    Section("Boxes Taken"){
                        if (takeArray.isEmpty){
                            Text("No entries.").foregroundColor(.gray)
                        } else {
                            HStack {
                                Toggle("View by trees", isOn: $displayTrees)
                            }
                            ForEach(takeArray, id: \.species){ species, boxes in
                                HStack{
                                    Text("\(species.name) (\(species.treesPerBox) / box) ")
                                    Spacer()
                                    displayTrees ?  Text("\(boxes*species.treesPerBox) trees") : Text("\(boxes) boxes")
                                    Spacer()
                                    displayTrees ? Text("\(utilities.formatFloat(float: (Float(boxes*species.treesPerBox) / Float(treesTaken))*100 ))%") : Text("\(utilities.formatFloat(float: (Float(boxes) / Float(boxesTaken))*100 ))%")
                                }
                            }
                            HStack{
                                Spacer()
                                displayTrees ? Text("Total Trees: \(treesTaken)") : Text("Total Boxes: \(boxesTaken)")
                                Spacer()
                            }
                            
                        }
                    }
                    
                    Section("Add to Boxes Taken"){
                        HStack{
                            Label("Species", systemImage: "leaf")
                            Spacer()
                            Picker("", selection: $selectedSpecies){
                                ForEach(speciesStore.species){ species in
                                    Text("\(species.name) (\(species.treesPerBox) trees / box)").frame(width: 100).tag(species)
                                }
                            }
                        }
                        HStack {
                            Label("Boxes", systemImage: "number")
                            Spacer()
                            TextField("ex. 20", text: $inputtedNumBoxes).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Spacer()
                            Button(action: AddBoxesTaken){
                                Text("Add")
                            }
                            Spacer()
                        }
                    }
                    
                    Section("Boxes Returned"){
                        if (returnArray.isEmpty){
                            Text("No entries.").foregroundColor(.gray)
                        } else {
                            HStack {
                                Toggle("View by trees", isOn: $displayTrees2)
                            }
                            ForEach(returnArray, id: \.species){ species, boxes in
                                HStack{
                                    Text("\(species.name) (\(species.treesPerBox) / box) ")
                                    Spacer()
                                    displayTrees2 ?  Text("\(boxes*species.treesPerBox) trees") : Text("\(boxes) boxes")
                                    Spacer()
                                    displayTrees2 ? Text("\(utilities.formatFloat(float: (Float(boxes*species.treesPerBox) / Float(treesReturned))*100 ))%") : Text("\(utilities.formatFloat(float: (Float(boxes) / Float(boxesReturned))*100 ))%")
                                }
                            }
                            HStack{
                                Spacer()
                                displayTrees2 ? Text("Total Trees: \(treesReturned)") : Text("Total Boxes: \(boxesReturned)")
                                Spacer()
                            }
                            
                        }
                    }
                    
                    Section("Add to Boxes Returned"){
                        HStack{
                            Label("Species", systemImage: "leaf")
                            Spacer()
                            Picker("", selection: $selectedSpecies2){
                                ForEach(speciesStore.species){ species in
                                    Text("\(species.name) (\(species.treesPerBox) trees / box)").frame(width: 100).tag(species)
                                }
                            }
                        }
                        HStack {
                            Label("Boxes", systemImage: "number")
                            Spacer()
                            TextField("ex. 20", text: $inputtedNumBoxes2).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Spacer()
                            Button(action: AddBoxesReturned){
                                Text("Add")
                            }
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear(){
            load()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("\(alertText.title)"),
                message: Text("\(alertText.message)")
            )
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action : {
                    isPresentingAddLoadView = false
                }){
                    Text("Dismiss")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action : {
                    if Validate() {
                        var boxesPerSpeciesTaken : [Species: Int] = [:]
                        for elem in takeArray {
                            boxesPerSpeciesTaken[elem.species] = elem.taken
                        }
                        
                        var boxesPerSpeciesRetured : [Species: Int] = [:]
                        for elem in returnArray {
                            boxesPerSpeciesRetured[elem.species] = elem.returned
                        }
                        
                        let newLoad = Load(date: selectedDate, boxesPerSpeciesTaken: boxesPerSpeciesTaken, boxesPerSpeciesReturned: boxesPerSpeciesRetured)
                        let index : Int = blockStore.blocks.firstIndex(where: { $0.blockNumber == block.blockNumber })!
                        blockStore.blocks[index].loads.append(newLoad)
                        
                        Task {
                            do {
                                try await BlockStore.save(blocks: blockStore.blocks)
                            } catch {
                                errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                            }
                        }
                        isPresentingAddLoadView = false
                    }
                } ) {
                    Text("Add")
                }
            }
        }
        .sheet(item: $errorWrapper) { wrapper in
            ErrorView(errorWrapper: wrapper)
        }
    }
}

//struct AddLoadView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddLoadView(block: Block.sampleData[0], selec isPresentingAddLoadView: .constant(true))
//    }
//}

