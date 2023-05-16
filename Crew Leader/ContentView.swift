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
    let savePersons: () -> Void
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CacheCalculatorView().tabItem { Label("Cache Calculator", systemImage: "plus.forwardslash.minus") }.tag(3)
            BlocksView(blocks: $blocks, saveBlocks: saveBlocks).tabItem{ Label("Blocks", systemImage: "map")}.tag(2)
            TalliesView(tallies: $tallies, saveTallies: saveTallies).tabItem { Label("Tallies", systemImage: "square.grid.3x3.square") }.tag(4)
            CrewView().tabItem { Label("Crew", systemImage: "person.3")}.tag(1)
            //Text("Plots tab").tabItem { Label("Plots", systemImage: "mappin.and.ellipse") }.tag(5)
            /// add plots tab tool to the block tab
            SettingsView(savePersons: savePersons, saveSpecies: saveSpecies).tabItem { Label("Settings", systemImage: "gear") }.tag(5)
            /*LineChartView<Int>(xyData: .constant([
                (x: "one", y: 1500),
                (x: "two", y: 1800),
                (x: "three", y: 2100),
                (x: "four", y: 2000),
                (x: "five", y: 2200),
                (x: "six", y: 2500),
                (x: "seven", y: 2200),
                (x: "eight", y: 2100),
                (x: "nine", y: 2250),
                (x: "ten", y: 2360),
                (x: "eleven", y: 2050),
                (x: "twelve", y: 1910),
                (x: "thirteen", y: 1820),
                (x: "fourteen", y: 2800),
                (x: "fifteen", y: 2680),
                (x: "sixteen", y: 2330),
                (x: "seventeen", y: 2560),
                (x: "eighteen", y: 2720),
                (x: "nineteen", y: 3020),
                (x: "twenty", y: 2940),
                (x: "twentyone", y: 2890),
                (x: "twentytwo", y: 3120),
            ]), w: W(W: 280, H: 180, O: CGPoint(x: 20,y: 180), SW: 50)).frame(height: 300).tabItem { Text("Line Chart View") }.tag(6)*/
        }.onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveTallies()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1, tallies: .constant(DailyTally.sampleData), blocks: .constant(Block.sampleData), saveTallies: {}, saveBlocks: {}, saveSpecies: {}, savePersons: {})
    }
}
