//
//  SettingsView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//

import SwiftUI

struct SettingsView: View {
    let saveSpecies : () -> Void
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section("Application Data"){
                        NavigationLink (destination: MyCrewView()){
                            Text("My Crew")
                        }
                        NavigationLink (destination: SpeciesListView(saveSpecies: saveSpecies)){
                            Text("Species List")
                        }
                    }
                }
            }.navigationTitle("Settings")
        }
      
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(saveSpecies: {})
    }
}
