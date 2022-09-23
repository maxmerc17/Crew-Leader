//
//  PersonStore.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//



import Foundation
import SwiftUI

class PersonStore: ObservableObject {
    @Published var persons: [Person] = []
    
    /// returns the sole crew leader
    func getCrewLeader() -> Person? {
        return persons.first(where: { $0.type == .crewLeader })
    }
    
    /// return crew members
    func getCrew() -> [Person]{
        return persons.filter{ $0.type == .crewMember || $0.type == .crewLeader }
    }
    
    /// return planter given their id
    func getPlanter(id: UUID) -> Person? {
        return persons.first(where: { $0.id == id }) ?? nil
    }
    
    /// returns a planter by their full name
    func getPlanter(fullName: String) -> Person? {
        return persons.first(where: { $0.fullName == fullName })
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false).appendingPathComponent("persons.data")
    }
    
    static func load() async throws -> [Person] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let persons):
                    continuation.resume(returning: persons)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Person], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let person = try JSONDecoder().decode([Person].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(person))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    @discardableResult
    static func save(persons: [Person]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(persons: persons) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let personsSaved):
                    continuation.resume(returning: personsSaved)
                }
            }
        }
    }
    
    static func save(persons: [Person], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(persons)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(persons.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}


