//
//  BlockStore.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-19.
//


import Foundation
import SwiftUI

class BlockStore: ObservableObject {
    @Published var blocks: [Block] = []
    
    /// return block object given block name
    func getBlock(blockName: String) -> Block? {
        return blocks.first(where: { $0.blockNumber == blockName })
    }
    
    /// returns all planting units, and the block name of where they are from, for the season in order of ealiest to latest work start date
    func getAllPlantingUnits() -> [(plantingUnit: PlantingUnit, block: String, id: Int)] {
        var returnArray : [(plantingUnit: PlantingUnit, block: String, id: Int)] = []
        let sortedBlocks = blocks.sorted(by: { $0.blockDetails.workStartDate > $1.blockDetails.workStartDate } )
        
        var count = 0
        for block in sortedBlocks {
            for plantingUnit in block.plantingUnits {
                returnArray.append((plantingUnit: plantingUnit, block: block.blockNumber, id: count))
                count += 1
            }
        }
        return returnArray
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false).appendingPathComponent("blocks.data")
    }
    
    static func load() async throws -> [Block] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let blocks):
                    continuation.resume(returning: blocks)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Block], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let block = try JSONDecoder().decode([Block].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(block))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(blocks: [Block]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(blocks: blocks) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let blocksSaved):
                    continuation.resume(returning: blocksSaved)
                }
            }
        }
    }
    
    static func save(blocks: [Block], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(blocks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(blocks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

