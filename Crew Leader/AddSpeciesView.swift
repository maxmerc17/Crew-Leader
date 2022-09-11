//
//  AddSpeciesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct AddSpeciesView: View {
    @State var selectedSpecies : Species = Species(data: Species.Data())
    @State var speciesList : [Species] = []//Species.sampleData
    
    func newSpeciesClicked(){
        speciesList.append(selectedSpecies)
    }
    
    var body: some View {
        Form{
            Section("Species"){
                ForEach(speciesList) { species in
                    Label("\(species.name)", systemImage: "leaf")
                }
                HStack{
                    Picker("Add Species", selection: $selectedSpecies){
                        ForEach(Species.sampleData) {
                            species in Text(species.name).tag(species)
                        }
                    }
                    Spacer()
                    
                }
                HStack{
                    Spacer()
                    Button(action : newSpeciesClicked){
                        Text("Add")
                    }
                    Spacer()
                }
            }
        }
    }
}

struct AddSpeciesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpeciesView()
    }
}
