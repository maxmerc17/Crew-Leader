//
//  ContentView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab : Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Blocks tab").tabItem { Label("Blocks", systemImage: "mappin.and.ellipse") }.tag(2)
            Text("Crew tab").tabItem { Label("Crew", systemImage: "person.3")}.tag(1)
            Text("Cache calculator tab").tabItem { Label("Cache Calculator", systemImage: "plus.forwardslash.minus") }.tag(3)
            TalliesView().tabItem { Label("Tallies", systemImage: "square.grid.3x3.square") }.tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1)
    }
}
