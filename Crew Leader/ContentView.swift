//
//  ContentView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

// TODO: remove the onchange code and make sure it doesn't break

import SwiftUI

struct ContentView: View {
    @State var selectedTab : Int = 3
    @Binding var tallies: [DailyTally]
    @Binding var blocks: [Block]
    
    @Environment(\.scenePhase) private var scenePhase
    
    let saveTallies : () -> Void
    let saveBlocks: () -> Void
    let saveSpecies: () -> Void
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CacheCalculatorView().tabItem { Label("Cache Calculator", systemImage: "plus.forwardslash.minus") }.tag(1)
            BlocksView(blocks: $blocks, saveBlocks: saveBlocks).tabItem{ Label("Blocks", systemImage: "map")}.tag(2)
            Text("Crew tab").tabItem { Label("Crew", systemImage: "person.3")}.tag(3)
            TalliesView(tallies: $tallies, saveTallies: saveTallies).tabItem { Label("Tallies", systemImage: "square.grid.3x3.square") }.tag(4)
            //Text("Plots tab").tabItem { Label("Plots", systemImage: "mappin.and.ellipse") }.tag(5)
            /// add plots tab tool to the block tab
            SettingsView(saveSpecies: saveSpecies).tabItem { Label("Settings", systemImage: "gear") }.tag(5)
        }.onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveTallies()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1, tallies: .constant(DailyTally.sampleData), blocks: .constant(Block.sampleData), saveTallies: {}, saveBlocks: {}, saveSpecies: {})
    }
}
