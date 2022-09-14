//
//  Block.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import Foundation

struct Block: Identifiable, Codable, Hashable, Comparable {
    var id: UUID
    var blockNumber : String
    var chatFreq : String // make enum
    var roadChannelFreq : String // make enum
    var towerTelChannel : String // make enum
    var lat : String
    var long : String
    var numWorkers : Int
    var workStartDate : Date
    var workFinishDate : Date
    var client : String // make enum
    var crewLeader : Person
    var firstAidAttendant : Person
    var supervisor : Person
    
    init(id: UUID, blockNumber: String, chatFreq: String, roadChannelFreq: String, towerTelChannel: String, lat: String, long: String, numWorkers: Int, workStartDate: Date, workFinishDate: Date, client: String, crewLeader: Person, firstAidAttendant: Person, supervisor: Person) {
        self.id = id
        self.blockNumber = blockNumber
        self.chatFreq = chatFreq
        self.roadChannelFreq = roadChannelFreq
        self.towerTelChannel = towerTelChannel
        self.lat = lat
        self.long = long
        self.numWorkers = numWorkers
        self.workStartDate = workStartDate
        self.workFinishDate = workFinishDate
        self.client = client
        self.crewLeader = crewLeader
        self.firstAidAttendant = firstAidAttendant
        self.supervisor = supervisor
    }
    
    static func < (lhs: Block, rhs: Block) -> Bool {
        if lhs.blockNumber < rhs.blockNumber{
            return true
        }else{ return false }
    }

}

extension Block {
    struct Data {
        var blockNumber : String = ""
        var chatFreq : String = ""// make enum
        var roadChannelFreq : String = ""// make enum
        var towerTelChannel : String = ""// make enum
        var lat : String = ""
        var long : String = ""
        var numWorkers : Int = 0
        var workStartDate : Date = Date.now
        var workFinishDate : Date = Date.now
        var client : String = ""// make enum
        var crewLeader : Person = Person(data: Person.Data())
        var firstAidAttendant : Person = Person(data: Person.Data())
        var supervisor : Person = Person(data: Person.Data())
    }
    
    init(data: Data) {
        id = UUID()
        blockNumber = data.blockNumber
        chatFreq = data.chatFreq
        roadChannelFreq = data.roadChannelFreq
        towerTelChannel = data.towerTelChannel
        lat = data.lat
        long = data.long
        numWorkers = data.numWorkers
        workStartDate = data.workStartDate
        workFinishDate = data.workFinishDate
        client = data.client
        crewLeader = data.crewLeader
        firstAidAttendant = data.firstAidAttendant
        supervisor = data.supervisor
    }
    
    mutating func update(data: Data){
        blockNumber = data.blockNumber
        chatFreq = data.chatFreq
        roadChannelFreq = data.roadChannelFreq
        towerTelChannel = data.towerTelChannel
        lat = data.lat
        long = data.long
        numWorkers = data.numWorkers
        workStartDate = data.workStartDate
        workFinishDate = data.workFinishDate
        client = data.client
        crewLeader = data.crewLeader
        firstAidAttendant = data.firstAidAttendant
        supervisor = data.supervisor
    }
}


extension Block {
    static let sampleData : [Block] =
        [
        Block(
            id: UUID(),
            blockNumber: "BUCK00510",
            chatFreq: "155.49",
            roadChannelFreq: "RR-17",
            towerTelChannel: "Houston",
            lat: "135123514.02305",
            long: "234234121.12352",
            numWorkers: 6,
            workStartDate: Date.now,
            workFinishDate: Date.now,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor),
        Block(
            id: UUID(),
            blockNumber: "OWEN0506",
            chatFreq: "155.49",
            roadChannelFreq: "RR-17",
            towerTelChannel: "Houston",
            lat: "135123514.02305",
            long: "234234121.12352",
            numWorkers: 6,
            workStartDate: Date.now,
            workFinishDate: Date.now,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor),
        Block(
            id: UUID(),
            blockNumber: "NADI002",
            chatFreq: "155.49",
            roadChannelFreq: "RR-17",
            towerTelChannel: "Houston",
            lat: "135123514.02305",
            long: "234234121.12352",
            numWorkers: 6,
            workStartDate: Date.now,
            workFinishDate: Date.now,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor)
        ]
}
