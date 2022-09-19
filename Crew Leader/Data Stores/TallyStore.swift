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
