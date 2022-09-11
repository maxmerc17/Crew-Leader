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
    var fullName : String {
        return firstName + " " + lastName
    }
    var birthDate : Date
    var plantingYear : Int
    
    init(id: UUID = UUID(), firstName: String, lastName: String, birthDate: Date, plantingYear: Int){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.plantingYear = plantingYear
    }
}

extension Person {
    struct Data {
        var firstName : String = "Max"
        var lastName : String = "Mercer"
        var birthDate : Date = Date.now
        var plantingYear : Int = 4
    }
    
    init(data: Data){
        id = UUID()
        firstName = data.firstName
        lastName = data.lastName
        birthDate = data.birthDate
        plantingYear = data.plantingYear
    }
    
    mutating func update(from data: Data){
        firstName = data.firstName
        lastName = data.lastName
        birthDate = data.birthDate
        plantingYear = data.plantingYear
    }
}

extension Person{
    static let sampleData: [Person] =
    [
        Person(firstName: "Max", lastName: "Mercer", birthDate: Date.now, plantingYear: 4),
        Person(firstName: "Sam", lastName: "Fedde", birthDate: Date.now, plantingYear: 3),
        Person(firstName: "Rianna", lastName: "Sundlie", birthDate: Date.now, plantingYear:2),
        Person(firstName: "Brandon", lastName: "Biglow", birthDate: Date.now, plantingYear: 2),
        Person(firstName: "Renaud", lastName: "Garnier-Belanger", birthDate: Date.now, plantingYear: 3),
        Person(firstName: "Preston", lastName: "Dunbar", birthDate: Date.now, plantingYear: 2)
    ]
    
    static let sampleSupervisor : Person = Person(id: UUID(), firstName: "Jake", lastName: "Stewardson", birthDate: Date.now, plantingYear: 10)
}


/*
 let formatter = DateFormatter()
 formatter.dateFormat = "yyyy/MM/dd HH:mm"
 let someDateTime = formatter.date(from: "2016/10/08 22:31")
 */
