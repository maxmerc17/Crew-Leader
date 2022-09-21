//
//  SpeciesStore.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//


import Foundation
import SwiftUI

class SpeciesStore: ObservableObject {
    @Published var blocks: [Species] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false).appendingPathComponent("species.data")
    }
    
    static func load() async throws -> [Species] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let species):
                    continuation.resume(returning: species)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Species], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let species = try JSONDecoder().decode([Species].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(species))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(species: [Species]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(species: species) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let speciesSaved):
                    continuation.resume(returning: speciesSaved)
                }
            }
        }
    }
    
    static func save(species: [Species], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(species)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(species.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}


