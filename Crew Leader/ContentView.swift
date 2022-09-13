//
//  ContentView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab : Int = 3
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Blocks tab").tabItem { Label("Blocks", systemImage: "mappin.and.ellipse") }.tag(1)
            Text("Cache calculator tab").tabItem { Label("Cache Calculator", systemImage: "plus.forwardslash.minus") }.tag(2)
            Text("Crew tab").tabItem { Label("Crew", systemImage: "person.3")}.tag(3)
            TalliesView().tabItem { Label("Tallies", systemImage: "square.grid.3x3.square") }.tag(4)
            Text("Settings").tabItem { Label("Settings", systemImage: "gear") }.tag(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1)
    }
}
