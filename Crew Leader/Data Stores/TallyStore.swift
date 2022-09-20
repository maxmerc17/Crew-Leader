//
//  TallyStore.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-19.
//

import Foundation
import SwiftUI

class TallyStore: ObservableObject {
    @Published var tallies: [DailyTally] = []
    
    /// returns number of trees planted for a given block
    func getTotalTreesPlanted(block: String) -> Int {
        var total = 0
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                total += blockTally.treesPlanted
            }
        }
        return total
    }
    
    /// returns average number of trees planted per day for a given block
    func getAverageTreesPerDay(block: String) -> Int {
        var total = getTotalTreesPlanted(block: block)
        var numDays = getTreesPerDate(block: block).count
        
        if numDays == 0 {
            return 0
        } else {
            return total/numDays
        }
    }
    
    /// returns number of trees planted per crew member for a given block
    func getTreesPerCrewMember(block: String) -> [String : Int]{
        var returnArray : [String: Int] = [:]
        
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                for (person, indvTally) in blockTally.individualTallies {
                    if returnArray[person.fullName] == nil {
                        returnArray[person.fullName] = indvTally.treesPlanted
                    } else {
                        returnArray[person.fullName] = returnArray[person.fullName]! + indvTally.treesPlanted
                    }
                    
                }
            }
        }
        return returnArray
    }
    
    /// returns number of trees planted per species for a given block
    func getTreesPerSpecies(block: String) -> [String: Int]{
        var returnArray : [String: Int] = [:]
        
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                for (species, treesPlanted) in blockTally.treesPlantedPerSpecies{
                    if returnArray[species.name] == nil{
                        returnArray[species.name] = treesPlanted
                    } else {
                        returnArray[species.name] = returnArray[species.name]! + treesPlanted
                    }
                }
            }
        }
        return returnArray
    }
    
    /// returns number of trees planted per date for a given block .. returns [date string : (trees planted, date object)]
    func getTreesPerDate(block: String) -> [String: (Int, Date)]{
        var returnArray : [String: (Int, Date)] = [:]
        
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                let formattedDate = utilities.formatDate(date: tally.date)
                if returnArray[formattedDate] == nil{
                    returnArray[formattedDate] = (blockTally.treesPlanted, tally.date)
                } else {
                    returnArray[formattedDate] = (returnArray[formattedDate]!.0 + blockTally.treesPlanted, returnArray[formattedDate]!.1)
                }
            }
        }
        
        
        return returnArray
    }
    
    
    /// LOAD AND SAVE
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false).appendingPathComponent("tallies.data")
    }
    
    static func load() async throws -> [DailyTally] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let tallies):
                    continuation.resume(returning: tallies)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[DailyTally], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                print(fileURL)
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let dailyTally = try JSONDecoder().decode([DailyTally].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(dailyTally))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(tallies: [DailyTally]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(tallies: tallies) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let blocksSaved):
                    continuation.resume(returning: blocksSaved)
                }
            }
        }
    }
    
    static func save(tallies: [DailyTally], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(tallies)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(tallies.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
