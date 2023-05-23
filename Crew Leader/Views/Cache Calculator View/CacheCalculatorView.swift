//
//  CacheCalculatorView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import SwiftUI

struct alertTextType {
    var title = ""
    var message = ""
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

struct CacheCalculatorView: View {
    @State var numberOfTrees = ""
    @State var cutsArray : [(Species, String)] = []
    
    @State var selectedSpecies = Species(data: Species.Data()) // updateOnAppear, FOD
    @State var mix = ""
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @State var isShowingResults = false
    @State var calculatedObject = CacheCalculator(data: CacheCalculator.Data())
    
    @State var history : [CacheCalculator] = []
    
    @EnvironmentObject var speciesStore : SpeciesStore
    
    @State var isPresentingImportView : Bool = false
    @State var selectedPlantingUnit : PlantingUnit = PlantingUnit.init(data: PlantingUnit.Data())

    @State var requirementsNotMet : Bool = false
    
    private enum Field: Int, CaseIterable { case username, password }
    @FocusState private var focusedField: Field?
    
    var totalPercentage : Int {
        return cutsArray.reduce(0) { tot, elem in tot + Int(elem.1)! } // !!
    }
    
    func load() {
        if !speciesStore.species.isEmpty{
            selectedSpecies = speciesStore.species[0]/// FOD
        } else {
            requirementsNotMet = true
        }
    }
    
    func addSpecies() {
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
        
        cutsArray.append((selectedSpecies, mix))
    }
    
    func calculate(){
        if numberOfTrees == "" {
            alertText.title = "Improper Input"
            alertText.message = "Enter number of trees."
            isShowingAlert = true
            return
        }
        if cutsArray.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Add at least one species to the list."
            isShowingAlert = true
            return
        }
        
        if totalPercentage != 100 {
            alertText.title = "Improper Input"
            alertText.message = "The sum of all species mixes should equal 100%."
            isShowingAlert = true
            return
        }
        
        calculatedObject = CacheCalculator(desiredTrees: Int(numberOfTrees)!, cuts: cutsArray)
        history.append(calculatedObject)
        isShowingResults = true
    }
    
    var body: some View {
        NavigationView {
            VStack{
                if selectedSpecies.name == "" {
                    if (requirementsNotMet){
                        VStack{
                            Text("Cache Calculator cannot load due to lack of species data.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                            Text("Species data may be taking longer to load. Or no species data exists.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                        }.padding()
                    }
                    Button(action: load){
                        Label("Reload", systemImage: "arrow.clockwise")
                    }
                } else {
                    Form{
                        Section("Input"){
                            HStack{
                                Label("Number of Trees ", systemImage: "number").frame(width: 200)
                                TextField("0", text: $numberOfTrees).multilineTextAlignment(.trailing).keyboardType(.numberPad).focused($focusedField, equals: .username)
                            }
                        }
                        
                        Section(cutsArray.count > 1 ? "Species - \(totalPercentage)%" : "Species"){
                            if cutsArray.isEmpty{
                                Text("No species entered.").foregroundColor(.gray)
                            } else {
                                ForEach($cutsArray, id: \.0) { $item in
                                    DisplayRowItem(species: $item.0, mix: $item.1, inputArray: $cutsArray)
                                }
                            }
                        }
                        
                        Section("Add Species"){
                            HStack {
                                Label("Species", systemImage: "leaf")
                                Picker("", selection: $selectedSpecies){
                                    ForEach(speciesStore.species){ species in
                                        Text("\(species.name) (\(species.treesPerBox) trees/box)").tag(species)
                                    }
                                }
                            }
                            HStack{
                                Label("Mix", systemImage: "percent")
                                TextField("ex. 67", text: $mix).multilineTextAlignment(.trailing).keyboardType(.numberPad).focused($focusedField, equals: .password)
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
                        
                        
                        
                        Section(""){
                            ZStack {
                                NavigationLink("View Results", destination: ResultsView(calculatedObject: calculatedObject), isActive: $isShowingResults).hidden()
                                HStack {
                                    Spacer()
                                    Button(action: calculate){
                                        Text("Calculate").foregroundColor(.green)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        Section("History"){
                            if history.isEmpty{
                                Text("No history to display").foregroundColor(.gray)
                            } else{
                                ForEach(history.reversed()){ co in
                                    NavigationLink(destination: ResultsView(calculatedObject: co)){
                                        HStack{
                                            Text("\(co.desiredTrees) ").font(.headline)
                                            HStack(alignment: .center){
                                                ForEach(co.cuts) { cut in
                                                    Text("\(cut.species.name) - \(cut.percent)%  ").font(.caption)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            Button("Close Keyboard") {
                                focusedField = nil
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cache Calculator")
            .onAppear(){
                load()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("\(alertText.title)"),
                    message: Text("\(alertText.message)")
                )
            }
            
            .toolbar {
                Button(action: { isPresentingImportView = true }){
                    Image(systemName: "arrow.down.circle")
                }
            }
            .sheet(isPresented: $isPresentingImportView){
                NavigationView(){
                    ImportPlantingUnitView(selectedPlantingUnit: $selectedPlantingUnit)
                        .toolbar(){
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingImportView = false
                                }
                            }
                            if !selectedPlantingUnit.cuts.isEmpty{
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Import") {
                                        cutsArray = selectedPlantingUnit.cuts.map { cut in (cut.species, String(cut.percent) ) }
                                        isPresentingImportView = false
                                    }
                                }
                            }
                            
                        }
                }
            }
        }
            
        
    }
}

struct DisplayRowItem: View {
    @Binding var species : Species
    @Binding var mix : String
    @Binding var inputArray : [(Species, String)]
    
    @State var isShowingAlert = false
    
    func removeItem(){
        let index = inputArray.firstIndex {$0 == (species, mix)}!
        inputArray.remove(at: index)
    }
    
    var body: some View {
        HStack{
            //Label("\(species.name)", systemImage: "leaf")
            Text(species.name)
            Spacer()
            Text("\(species.treesPerBox) trees / box")
            Spacer()
            Text("\(mix)%")
            Spacer()
            Button(action: removeItem){
                Image(systemName: "minus.circle")
            }.help("Remove Item")
        }
    }
}

struct CacheCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CacheCalculatorView().environmentObject(SpeciesStore())
    }
}

struct DisplayRowItem_Previews: PreviewProvider {
    static var previews: some View {
        DisplayRowItem(species: .constant(Species.sampleData[0]), mix: .constant("100"), inputArray: .constant([(Species.sampleData[0], "100")]))
    }
}
