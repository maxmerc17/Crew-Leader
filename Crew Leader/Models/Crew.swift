//
//  Crew.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import Foundation

struct Crew : Identifiable, Codable {
    var id: UUID
    var leader: Person
    var members: [Person]
    var pastMembers: [Person]!
    var size : Int {
        return members.count
    }
    var type : String {
        return "\(size) Pack"
    }
    var name : String {
        return "\(leader.firstName)'s Crew"
    }
    init(id: UUID = UUID(), leader: Person, members: [Person]){
        self.id = id
        self.leader = leader
        self.members = members
        self.pastMembers = nil
    }
}

extension Crew {
    struct Data {
        var leader: Person = Person(data: Person.Data())
        var members: [Person] = [Person(data: Person.Data())]
        var pastMembers: [Person]! = nil
    }
    
    init(data: Data){
        id = UUID()
        leader = data.leader
        members = data.members
        pastMembers = data.pastMembers
    }
    
    mutating func update(data: Data) {
        leader = data.leader
        members = data.members
        pastMembers = data.pastMembers
    }
}

extension Crew {
    static let sampleData: Crew = Crew(leader: Person.sampleData[0], members: Person.sampleData)
    static let sampleCrew: Crew = Crew(leader: Person.sampleData[0], members: Person.sampleData)
    
}


