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
    
    func addSpecies() {
        if inputtedSpeciesCode.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for species code."
            isShowingAlert = true
            return
        }
        
        if inputtedTreesPerBox.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for trees per box."
            isShowingAlert = true
            return
        }
        
        if !inputtedTreesPerBox.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be an integer."
            isShowingAlert = true
            return
        }
        
        if Int(inputtedTreesPerBox)! <= 0 || Int(inputtedTreesPerBox)! > 1000{
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be an integer between 0 and 1000."
            isShowingAlert = true
            return
        }
        
        if inputtedTreesPerBundle.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for trees per bundle."
            isShowingAlert = true
            return
        }
        
        if !inputtedTreesPerBundle.isNumber {
            alertText.title = "Improper Input"
            alertText.message = "Trees per bundle must be an integer."
            isShowingAlert = true
            return
        }
        
        if Int(inputtedTreesPerBundle)! <= 0 || Int(inputtedTreesPerBundle)! > 1000{
            alertText.title = "Improper Input"
            alertText.message = "Trees per bundle must be an integer between 0 and 1000."
            isShowingAlert = true
            return
        }
        
        if Int(inputtedTreesPerBox)! % Int(inputtedTreesPerBundle)! != 0 ||
            Int(inputtedTreesPerBox)! < Int(inputtedTreesPerBundle)!{
            alertText.title = "Improper Input"
            alertText.message = "Trees per box must be divisible by trees per bundle."
            isShowingAlert = true
            return
        }
        
        if speciesStore.exists(name: inputtedSpeciesCode) {
                alertText.title = "Invalid Input"
                alertText.message = "Species code already exists. Species code must be unique."
                isShowingAlert = true
                return
        }
        
        let newSpecies = Species(name: inputtedSpeciesCode, treesPerBox: Int(inputtedTreesPerBox)!, treesPerBundle: Int(inputtedTreesPerBundle)!)
        speciesStore.species.append(newSpecies)
        saveSpecies()
    }
    
    var body: some View {
        VStack{
            Form{
                Section("Input New Species"){
                    HStack{
                        Label("Species Code:", systemImage: "textformat")
                        Spacer()
                        TextField("ex. PLI048", text: $inputtedSpeciesCode).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Label("Trees Per Box", systemImage: "shippingbox")
                        Spacer()
                        TextField("ex. 420", text: $inputtedTreesPerBox).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Label("Trees Per Bundle", systemImage: "pause.rectangle")
                        Spacer()
                        TextField("ex. 20", text: $inputtedTreesPerBundle).frame(width: 129).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Spacer()
                        Button(action: addSpecies){
                            Text("Add")
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
    }
}

struct SpeciesListView_Previews: PreviewProvider {
    static var previews: some View {
        SpeciesListView(saveSpecies: {}).environmentObject(SpeciesStore())
    }
}
