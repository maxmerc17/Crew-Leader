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
        let total = getTotalTreesPlanted(block: block)
        let numDays = getTreesPerDate(block: block).count
        
        if numDays == 0 {
            return 0
        } else {
            return total/numDays
        }
    }
    
    /// returns total number of trees planted per crew member for a given block
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
    
    /// returns total number of trees planted per species for a given block
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
    
    /// returns total number of trees planted per date for a given block .. returns [date string : (trees planted, date object)]
    func getTreesPerDate(block: String) -> [(day: String, trees: Int)]{
        var tempArray : [String: (trees: Int, date: Date)] = [:]
        var returnArray : [(day: String, trees: Int)]
        
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                let formattedDate = utilities.formatDate(date: tally.date)
                if tempArray[formattedDate] == nil{
                    tempArray[formattedDate] = (blockTally.treesPlanted, tally.date)
                } else {
                    tempArray[formattedDate] = (tempArray[formattedDate]!.0 + blockTally.treesPlanted, tempArray[formattedDate]!.1)
                }
            }
        }
        
        let sortedArrray = tempArray.sorted(by: { $0.value.date < $1.value.date })
        returnArray = sortedArrray.map { (day: $0.key, trees: $0.value.trees)}
        return returnArray
    }
    
    /// returns total number of trees planted per day for a given block and person
    func getTreesPerDate(block: String, person: Person) -> [(day: String, trees: Int)]{
        var returnArray : [(day: String, trees: Int)] = []
        var tempArray : [String: (trees: Int, date: Date)] = [:]
        
        for tally in tallies {
            if let blockTally = tally.blocks[block]{
                //if let indvTally = blockTally.individualTallies[person]{ -- this is the line that you want to have work
                for (key, indvTally) in blockTally.individualTallies{ // -- then remove this line
                    if key.fullName == person.fullName{ //               -- and this line
                        let formattedDate = utilities.formatDate(date: tally.date)
                        if tempArray[formattedDate] == nil{
                            tempArray[formattedDate] = (indvTally.treesPlanted, tally.date)
                        } else {
                            tempArray[formattedDate] = (tempArray[formattedDate]!.trees + indvTally.treesPlanted, tally.date)
                        }
                    }
                }
            }
        }
        
        let sortedArrray = tempArray.sorted(by: { $0.value.date < $1.value.date })
        returnArray = sortedArrray.map { (day: $0.key, trees: $0.value.trees)}

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
