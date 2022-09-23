//
//  Person.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-09.
//

import Foundation

struct Person: Identifiable, Codable, Hashable{
    var id: UUID
    var firstName : String
    var lastName : String
    var email: String
    var type: PersonType // crew leader, crew member, past crew member, guest planter, supervisor // good to use enum here
    
    var fullName : String {
        return firstName + " " + lastName
    }
    
    init(id: UUID = UUID(), firstName: String, lastName: String, email: String, type: PersonType){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.type = type
    }
}

enum PersonType: String, Codable {
    case crewLeader = "Crew Leader"
    case crewMember = "Crew Member"
    case pastCrewMember = "Past Crew Member"
    case guestPlanter = "Guest Planter"
    case supervisor = "Supervisor"
}

extension Person {
    struct Data {
        var firstName : String = ""
        var lastName : String = ""
        var email: String = ""
        var type: PersonType = PersonType.crewMember
    }
    
    init(data: Data){
        id = UUID()
        firstName = data.firstName
        lastName = data.lastName
        email = data.email
        type = data.type
    }
    
    mutating func update(from data: Data){
        firstName = data.firstName
        lastName = data.lastName
        email = data.email
        type = data.type
    }
}

extension Person{
    static let sampleData: [Person] =
    [
        Person(firstName: "Max", lastName: "Mercer", email: "maxmercer@gmail.com", type: PersonType.crewLeader),
        Person(firstName: "Sam", lastName: "Fedde", email: "samfedde@gmail.com", type: PersonType.crewMember),
        Person(firstName: "Rianna", lastName: "Sundlie", email: "riannasundlie@gmail.com", type: PersonType.crewMember),
        Person(firstName: "Brandon", lastName: "Biglow", email: "brandonbiglow@gmail.com", type: PersonType.crewMember),
        Person(firstName: "Renaud", lastName: "Garnier-Belanger", email: "rendaudgarnier-belanger@gmail.com", type: PersonType.crewMember),
        Person(firstName: "Preston", lastName: "Dunbar", email: "prestondunbar@gmail.com", type: PersonType.crewMember)
    ]
    
    static let sampleSupervisor : Person = Person(id: UUID(), firstName: "Jake", lastName: "Stewardson", email: "jakestewardson@gmail.com",  type: PersonType.supervisor)
}


/*
 let formatter = DateFormatter()
 formatter.dateFormat = "yyyy/MM/dd HH:mm"
 let someDateTime = formatter.date(from: "2016/10/08 22:31")
 */
