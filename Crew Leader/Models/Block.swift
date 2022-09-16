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
    var blockDetails : BlockDetails
    var plantingUnits : [PlantingUnit]
    var loads : [Load]
    
    init(id: UUID, blockNumber: String, chatFreq: String, roadChannelFreq: String, towerTelChannel: String, lat: String, long: String, numWorkers: Int, workStartDate: Date, workFinishDate: Date?, client: String, crewLeader: Person, firstAidAttendant: Person, supervisor: Person, plantingUnits : [PlantingUnit], loads: [Load]) {
        self.id = id
        self.blockNumber = blockNumber
        
        var data = BlockDetails.Data()
        data.chatFreq = chatFreq
        data.roadChannelFreq = roadChannelFreq
        data.towerTelChannel = towerTelChannel
        data.lat = lat
        data.long = long
        data.numWorkers = numWorkers
        data.workStartDate = workStartDate
        data.workFinishDate = workFinishDate
        data.client = client
        data.crewLeader = crewLeader
        data.firstAidAttendant = firstAidAttendant
        data.supervisor = supervisor
        self.blockDetails = BlockDetails(data: data)
        
        self.plantingUnits = plantingUnits
        self.loads = loads
    }
    
    init(id: UUID, blockNumber: String){
        self.id = id
        self.blockNumber = blockNumber
        self.blockDetails = BlockDetails(data: BlockDetails.Data())
        self.plantingUnits = []
        self.loads = []
    }
    
    static func < (lhs: Block, rhs: Block) -> Bool {
        if lhs.blockNumber < rhs.blockNumber{
            return true
        }else{ return false }
    }
    
    static func == (lhs: Block, rhs: Block) -> Bool {
        return (lhs.blockNumber == rhs.blockNumber)
    }
}

extension Block {
    struct Data {
        var blockNumber : String = ""
        var blockDetails : BlockDetails = BlockDetails(data: BlockDetails.Data())
        var plantingUnits : [PlantingUnit] = []
        var loads : [Load] = []
    }
    
    init(data: Data) {
        id = UUID()
        blockNumber = data.blockNumber
        blockDetails = data.blockDetails
        plantingUnits = data.plantingUnits
        loads = data.loads
    }
    
    mutating func update(data: Data){
        blockNumber = data.blockNumber
        blockDetails = data.blockDetails
        plantingUnits = data.plantingUnits
        loads = data.loads
    }
}

struct BlockDetails : Codable, Hashable {
    var chatFreq : String // make enum
    var roadChannelFreq : String // make enum
    var towerTelChannel : String // make enum
    var lat : String
    var long : String
    var numWorkers : Int
    var workStartDate : Date
    var workFinishDate : Date?
    var client : String // make enum
    var crewLeader : Person
    var firstAidAttendant : Person
    var supervisor : Person
}

extension BlockDetails {
    struct Data {
        var chatFreq : String = ""// make enum
        var roadChannelFreq : String = ""// make enum
        var towerTelChannel : String = ""// make enum
        var lat : String = ""
        var long : String = ""
        var numWorkers : Int = 0
        var workStartDate : Date = Date.now
        var workFinishDate : Date? = nil
        var client : String = ""// make enum
        var crewLeader : Person = Person(data: Person.Data())
        var firstAidAttendant : Person = Person(data: Person.Data())
        var supervisor : Person = Person(data: Person.Data())
    }
    
    init(data: Data){
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

struct PlantingUnit : Identifiable, Codable, Hashable{
    var id: UUID
    var area: Float
    var density: Int
    var TreesPU: Int
    var cuts: [Cut]
    
    var plotDensity: Int {
        density / 200
    }
    
    init(id: UUID = UUID(), area: Float, density: Int, TreesPU: Int, cuts: [Cut]) {
        self.id = id
        self.area = area
        self.density = density
        self.TreesPU = TreesPU
        self.cuts = cuts
    }
    
    init(id: UUID = UUID(), area: Float, density: Int, TreesPU: Int) {
        self.id = id
        self.area = area
        self.density = density
        self.TreesPU = TreesPU
        self.cuts = []
    }
}

extension PlantingUnit{
    struct Data {
        var area: Float
        var density: Int
        var TreesPU: Int
        var cuts : [Cut]
    }
    
    init(data: Data){
        self.id = UUID()
        self.area = 0
        self.density = 0
        self.TreesPU = 0
        self.cuts = []
    }
    
    mutating func upate(data: Data){
        area = data.area
        density = data.density
        TreesPU = data.TreesPU
        cuts = data.cuts
    }
}


struct Load: Identifiable, Codable, Hashable {
    var id : UUID
    var date : Date
    var boxesPerSpeciesTaken : [Species: Int]
    var boxesPerSpeciesReturned : [Species: Int]
    
    var treesTaken : Int {
        boxesPerSpeciesTaken.reduce(0, { x, y in x + (y.0.treesPerBox*y.1) })
    }
    var treesReturned : Int {
        boxesPerSpeciesReturned.reduce(0, { x, y in x + (y.0.treesPerBox*y.1) })
    }
    
    init(id: UUID, date: Date, boxesPerSpeciesTaken: [Species: Int], boxesPerSpeciesReturned: [Species: Int]) {
        self.id = id
        self.date = date
        self.boxesPerSpeciesTaken = boxesPerSpeciesTaken
        self.boxesPerSpeciesReturned = boxesPerSpeciesReturned
    }
    
    static func == (lhs: Load, rhs: Load) -> Bool {
        lhs.id == rhs.id
    }
}

extension Load {
    struct Data {
        var date : Date
        var boxesPerSpeciesTaken : [Species: Int]
        var boxesPerSpeciesReturned : [Species: Int]
    }
    
    init(data: Data){
        id = UUID()
        date = data.date
        boxesPerSpeciesTaken = data.boxesPerSpeciesTaken
        boxesPerSpeciesReturned = data.boxesPerSpeciesReturned
    }
    
    mutating func update(data: Data){
        date = data.date
        boxesPerSpeciesTaken = data.boxesPerSpeciesTaken
        boxesPerSpeciesReturned = data.boxesPerSpeciesReturned
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
            workFinishDate: nil,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor,
            plantingUnits: [],
            loads: []),
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
            workFinishDate: nil,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor,
            plantingUnits: [],
            loads: []),
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
            workFinishDate: nil,
            client: "Canfor",
            crewLeader: Person.sampleData[0],
            firstAidAttendant: Person.sampleData[0],
            supervisor: Person.sampleSupervisor,
            plantingUnits: [],
            loads: [])
        ]
}
