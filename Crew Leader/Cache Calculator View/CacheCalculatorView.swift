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
    
    @State var selectedSpecies = Species.sampleData[0]
    @State var mix = ""
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @State var isShowingResults = false
    @State var calculatedObject = CacheCalculator(data: CacheCalculator.Data())

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
        
        calculatedObject = CacheCalculator(desiredTrees: Int(numberOfTrees)!, cuts: cutsArray)
        isShowingResults = true
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section("Input"){
                    HStack{
                        Label("Number of Trees: ", systemImage: "number")
                        TextField("0", text: $numberOfTrees).frame(width:80)
                    }
                    ForEach($cutsArray, id: \.0) { $item in
                        DisplayRowItem(species: $item.0, mix: $item.1, inputArray: $cutsArray, index: cutsArray.firstIndex {$0 == item}! )
                    }
                }
                Section("Add Species"){
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
                
                
            }
            .navigationTitle("Cache Calculator")
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("\(alertText.title)"),
                    message: Text("\(alertText.message)")
                )
            }
        }
            
        
    }
}

struct DisplayRowItem: View {
    @Binding var species : Species
    @Binding var mix : String
    @Binding var inputArray : [(Species, String)]
    
    @State var index : Int
    @State var isShowingAlert = false
    var body: some View {
        HStack{
            Label("\(species.name)", systemImage: "leaf")
            Spacer()
            Text("\(species.numTrees) trees / box")
            Spacer()
            Text("\(mix)%")
            Spacer()
        }
    }
}

struct CacheCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CacheCalculatorView()
    }
}

struct DisplayRowItem_Previews: PreviewProvider {
    static var previews: some View {
        DisplayRowItem(species: .constant(Species.sampleData[0]), mix: .constant("100"), inputArray: .constant([(Species.sampleData[0], "100")]), index: 1)
    }
}
