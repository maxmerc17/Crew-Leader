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
    
    var totalAlloction : Int {
        return plantingUnits.reduce(0) { tot, pu in
            tot + pu.TreesPU
        }
    }
    
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
    /// returns loads as an data array that can be used for a chart
    func getLoadsData() -> [(day: String, boxesTaken: Int, boxesReturned: Int)] {
        var returnArray : [(day: String, boxesTaken: Int, boxesReturned: Int)] = []
        var tempArray : [(day: String, date: Date, boxesReturned: Int, boxesTaken: Int)] = []
        for load in loads {
            let day = utilities.formatDate(date: load.date)
            if let index = tempArray.firstIndex(where: { $0.day == day }){
                tempArray[index].boxesTaken += load.boxesTaken
                tempArray[index].boxesReturned += load.boxesReturned
            } else {
                tempArray.append((day: day, date: load.date, boxesReturned: load.boxesReturned, boxesTaken: load.boxesTaken))
            }
        }
        
        tempArray = tempArray.sorted { $0.date < $1.date }
        returnArray = tempArray.map{ (day: utilities.formatDate(date: $0.date), boxesTaken: $0.boxesTaken, boxesReturned: $0.boxesReturned ) }
        
        return returnArray
    }
    
    func getBoxesPerSpeciesTaken(species: Species) -> Int{
        loads.reduce(0) { tot, elem in
            tot + (elem.boxesPerSpeciesTaken[species] ?? 0) - (elem.boxesPerSpeciesReturned[species] ?? 0)
        }
    }
    
    
    // MARK: Planting Summary
    func getBoxesToBringPerSpecies() -> [(species: Species, boxesToBring: Int)]{
        var array : [(species: Species, boxesToBring: Int)] = []
        
        for plantingUnit in plantingUnits {
            for cut in plantingUnit.cuts {
                if let index = array.firstIndex(where: { $0.species == cut.species }){
                    array[index].boxesToBring += cut.numBoxes(plantingUnit.TreesPU)
                }
                else {
                    array.append((species: cut.species, boxesToBring: cut.numBoxes(plantingUnit.TreesPU)))
                }
            }
        }
        return array
    }
    
    func getCutsPerPlantingUnit() -> [(Species, String, Int)]{
        var array : [(Species, String, Int)] = []
        
        var unitNumber = 1
        for plantingUnit in plantingUnits {
            for cut in plantingUnit.cuts {
                array.append((cut.species, String(cut.percent), unitNumber))
            }
            unitNumber+=1
        }
        return array
    }
    
    /// given a planting unit the unit number in the block is returned
    func getUnitNumber(_ plantingUnit: PlantingUnit) -> Int? {
        if let index = plantingUnits.firstIndex(of: plantingUnit ){
            return index + 1
        }
        else {
            return nil
        }
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
    struct Data : Equatable {
        var area: Float = 0
        var density: Int = 0
        var TreesPU: Int = 0
        var cuts : [Cut] = []
    }
    
    init(data: Data){
        self.id = UUID()
        self.area = data.area
        self.density = data.density
        self.TreesPU = data.TreesPU
        self.cuts = data.cuts
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
    
    var boxesTaken : Int {
        boxesPerSpeciesTaken.reduce(0) { tot, elem in tot + elem.value }
    }
    
    var boxesReturned : Int {
        boxesPerSpeciesReturned.reduce(0) { tot, elem in tot + elem.value }
    }
    
    var treesTaken : Int {
        boxesPerSpeciesTaken.reduce(0, { x, y in x + (y.0.treesPerBox*y.1) })
    }
    var treesReturned : Int {
        boxesPerSpeciesReturned.reduce(0, { x, y in x + (y.0.treesPerBox*y.1) })
    }
    
    init(id: UUID = UUID(), date: Date, boxesPerSpeciesTaken: [Species: Int], boxesPerSpeciesReturned: [Species: Int]) {
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
    func getBoxesTakenTuple() -> [(species: Species, boxes: Int)] {
        return boxesPerSpeciesTaken.map{ ($0.key, $0.value) }
    }
    
    func getBoxesReturnedTuple() -> [(species: Species, boxes: Int)] {
        return boxesPerSpeciesReturned.map{ ($0.key, $0.value) }
    }
}

extension Load {
    struct Data {
        var date : Date = Date.now
        var boxesPerSpeciesTaken : [Species: Int] = [:]
        var boxesPerSpeciesReturned : [Species: Int] = [:]
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
