//
//  CacheCalculatorView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-14.
//

import SwiftUI

struct CacheCalculatorView: View {
    @State var numberOfTrees = ""
    @State var inputArray : [(Species, String)] = [(Species.sampleData[0], "100")]
    
    @State var isShowingAlert = false
    func addRowItem() {
        let species = inputArray.map { $0.0 }
        let newSpecies = Species.sampleData.first(where: {!species.contains($0)}) ?? nil
        if let newSpecies {
            inputArray.append((newSpecies, "0"))
        }else {
            isShowingAlert = true
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .trailing){
                    HStack{
                        Label("Enter Number of Trees: ", systemImage: "number")
                        TextField("0", text: $numberOfTrees).frame(width:80)
                    }.padding()
                    ForEach($inputArray, id: \.0) { $item in
                        DisplayRowItem(species: $item.0, mix: $item.1, inputArray: $inputArray, selectedSpecies: item.0)
                    }
                }
                
            }
            .navigationTitle("Cache Calculator")
            .toolbar {
                Button(action: addRowItem){
                    Text("Add Species")
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Cannot Add Another Species"),
                    message: Text("All species types are in the list.")
                )
            }
        }
            
        
    }
}

struct DisplayRowItem: View {
    @Binding var species : Species
    @Binding var mix : String
    @Binding var inputArray : [(Species, String)]
    
    @State var selectedSpecies : Species
    var selectionList : [Species] {
        get {
            let speciesArray = inputArray.map { $0.0 }
            return Species.sampleData.filter {!speciesArray.contains($0)}
        }
    }
    
    func rejectSelection(prevSelection: Species) {
        selectedSpecies = prevSelection
        isShowingAlert = true
    }
    
    func acceptSelection(newVal: Species) {
        species = newVal
    }
    
    @State var isShowingAlert = false
    var body: some View {
        
        HStack{
            Picker("Select Species", selection: $selectedSpecies){
                ForEach(Species.sampleData){ species in
                    Text("\(species.name)").tag(species)
                }
            }.onChange(of: selectedSpecies){[selectedSpecies] newValue in
                if inputArray.contains(where: { $0.0 == newValue }){
                    rejectSelection(prevSelection: selectedSpecies)
                } else {
                    acceptSelection(newVal: newValue)
                }
            }
            Spacer()
            TextField("% mix", text: $mix)
            
        }.padding()
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Cannot Select Species"),
                    message: Text("The selected species is already in the list.")
                )
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
        DisplayRowItem(species: .constant(Species.sampleData[0]), mix: .constant("100"), inputArray: .constant([(Species.sampleData[0], "100")]), selectedSpecies: Species.sampleData[0])
    }
}
