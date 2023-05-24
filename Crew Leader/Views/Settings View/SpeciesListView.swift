//
//  SpeciesListView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//

import SwiftUI

struct SpeciesListView: View {
    let saveSpecies: () -> Void
    
    @EnvironmentObject var speciesStore : SpeciesStore
    
    @State var inputtedSpeciesCode: String = ""
    @State var inputtedTreesPerBox: String = ""
    @State var inputtedTreesPerBundle: String = ""
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @State var isShowingSaveAlert: Bool = false
    
    func validate() -> Bool {
        if inputtedSpeciesCode.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for species code."
            isShowingAlert = true
            return false
        }
        
        if inputtedTreesPerBox.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for trees per box."
            isShowingAlert = true
            return false
        }
        
        if !inputtedTreesPerBox.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be an integer."
            isShowingAlert = true
            return false
        }
        
        if Int(inputtedTreesPerBox)! <= 0 || Int(inputtedTreesPerBox)! > 1000{
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be an integer between 0 and 1000."
            isShowingAlert = true
            return false
        }
        
        if inputtedTreesPerBundle.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for trees per bundle."
            isShowingAlert = true
            return false
        }
        
        if !inputtedTreesPerBundle.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Trees per bundle must be an integer."
            isShowingAlert = true
            return false
        }
        
        if Int(inputtedTreesPerBundle)! <= 0 || Int(inputtedTreesPerBundle)! > 1000{
            alertText.title = "Improper Input"
            alertText.message = "Trees per bundle must be an integer between 0 and 1000."
            isShowingAlert = true
            return false
        }
        
        if Int(inputtedTreesPerBox)! % Int(inputtedTreesPerBundle)! != 0 ||
            Int(inputtedTreesPerBox)! < Int(inputtedTreesPerBundle)!{
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be divisible by trees per bundle."
            isShowingAlert = true
            return false
        }
        
        if speciesStore.exists(name: inputtedSpeciesCode) {
                alertText.title = "Invalid Input"
                alertText.message = "Species code already exists. Species code must be unique."
                isShowingAlert = true
                return false
        }
        return true
    }
    
    func add_species() {
        let newSpecies = Species(name: inputtedSpeciesCode, treesPerBox: Int(inputtedTreesPerBox)!, treesPerBundle: Int(inputtedTreesPerBundle)!)
        speciesStore.species.append(newSpecies)
        saveSpecies()
        inputtedSpeciesCode = ""
        inputtedTreesPerBox = ""
        inputtedTreesPerBundle = ""
    }
    
    private enum Field: Int, CaseIterable { case username, password, third, fourth } // case names are random. its the function that counts
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack{
            Form{
                Text("Reminder: Don't fuck it up. You cannot delete or update a species. Sometimes the same species code can be used for boxes with different contents. If you have two of the same species code in a season then name them uniquely here. Ex: { 'PINE_1': x bundles, y trees/bundle } and { 'PINE_2': z bundles, w trees/bundle }. Keep species names short. ").font(.custom(
                    "AmericanTypewriter",
                    fixedSize: 16)).padding()
                Section("Input New Species"){
                    HStack{
                        Label("Species Code:", systemImage: "textformat")
                        Spacer()
                        TextField("ex. PINE_1", text: $inputtedSpeciesCode).frame(width: 148).multilineTextAlignment(.trailing).focused($focusedField, equals: .username)
                    }
                    HStack{
                        Label("Trees Per Box", systemImage: "shippingbox")
                        Spacer()
                        TextField("ex. 420", text: $inputtedTreesPerBox).frame(width: 148).multilineTextAlignment(.trailing).focused($focusedField, equals: .password)
                    }
                    HStack{
                        Label("Trees Per Bundle", systemImage: "pause.rectangle")
                        Spacer()
                        TextField("ex. 20", text: $inputtedTreesPerBundle).frame(width: 129).multilineTextAlignment(.trailing).focused($focusedField, equals: .third)
                    }
                    HStack {
                        Spacer()
                        Button(action: { if validate() { isShowingSaveAlert = true } } ){
                            Text("Add")
                        }.alert(isPresented: $isShowingSaveAlert) {
                            Alert(
                                title: Text("Add Species?"),
                                message: Text("You cannot update or delete a species later"),
                                primaryButton: .default(Text("Yes! Add.")) {
                                    add_species()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        Spacer()
                    }
                }
            
                Section("Existing Species"){
                    if speciesStore.species.isEmpty {
                        Text("No existing species").foregroundColor(.gray)
                    }
                    
                    ForEach(speciesStore.species){ species in
                        HStack{
                            Text("\(species.name)")
                            Spacer()
                            Text("\(species.treesPerBox) trees/box")
                            Spacer()
                            Text("\(species.treesPerBundle) trees/bundle")
                        }
                    }
                }
            }
        }
        .navigationTitle("Species List")
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("\(alertText.title)"),
                message: Text("\(alertText.message)")
            )
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

struct SpeciesListView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesListView(saveSpecies: {}).environmentObject(SpeciesStore())
    }
}
