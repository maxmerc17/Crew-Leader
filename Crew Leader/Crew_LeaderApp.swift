//
//  Crew_LeaderApp.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import SwiftUI

@main
struct Crew_LeaderApp: App {
    @StateObject private var tallyStore = TallyStore()
    @StateObject private var blockStore = BlockStore()
    
    @State private var errorWrapper: ErrorWrapper?
    
    func saveTallies() {
        Task {
            do {
                try await TallyStore.save(tallies: tallyStore.tallies)
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
            }
        }
    }
    
    func saveBlocks() {
        Task {
            do {
                try await BlockStore.save(blocks: blockStore.blocks)
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(selectedTab: 1,
                            
                            tallies: $tallyStore.tallies,
                            blocks: $blockStore.blocks,
                            
                            saveTallies: saveTallies,
                            saveBlocks: saveBlocks)
            }
            .environmentObject(blockStore)
            .task {
                do {
                    tallyStore.tallies = try await TallyStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Crew leader will load sample data and continue.")
                }
            }
            .task {
                do {
                    blockStore.blocks = try await BlockStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Crew leader will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                tallyStore.tallies = DailyTally.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
        
    }
}
