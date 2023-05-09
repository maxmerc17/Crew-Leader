//
//  MyCrewView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//

import SwiftUI

let AddState: String = "AddState"
let UpdateState: String = "UpdateState"

struct MyCrewView: View {
    let savePersons: () -> Void
    
    @State var inputtedFirstName: String = ""
    @State var inputtedLastName: String = ""
    @State var inputtedEmail: String = ""
    @State var inputtedType: PersonType = .crewMember
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    @State var PageState : String = AddState
    
    @EnvironmentObject var personStore : PersonStore
    
    func addPerson() {
        if inputtedFirstName.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for first name."
            isShowingAlert = true
            return
        }
        if inputtedLastName.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for last name."
            isShowingAlert = true
            return
        }
        if inputtedEmail.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for email."
            isShowingAlert = true
            return
        }
        
        if let _ = personStore.getCrewLeader(), inputtedType == .crewLeader {
            alertText.title = "Invalid Input"
            alertText.message = "There is already a crew leader."
            isShowingAlert = true
            return
        }
        let fullName = inputtedFirstName + " " + inputtedLastName
        if let _ = personStore.getPlanter(fullName: fullName) {
            alertText.title = "Invalid Input"
            alertText.message = "There is already a person with the same first and last name. Please update your first name or last name to make it unique. Recommended to update first name with an additional _."
            isShowingAlert = true
            return
        }
        
        let newPerson = Person(firstName: inputtedFirstName, lastName: inputtedLastName, email: inputtedEmail, type: inputtedType)
        personStore.persons.append(newPerson)
        savePersons()
        
        inputtedFirstName = ""
        inputtedLastName = ""
        inputtedEmail = ""
        inputtedType = PersonType.crewMember
    }
    
    func updatePerson() {
        self.PageState = UpdateState
        return
    }
    
    var body: some View {
        Form{
            Section("Input New Person"){
                HStack{
                    Label("First Name", systemImage: "textformat")
                    Spacer()
                    TextField("John", text: $inputtedFirstName).frame(width: 148).multilineTextAlignment(.trailing)
                }
                HStack{
                    Label("Last Name", systemImage: "textformat")
                    Spacer()
                    TextField("Smith", text: $inputtedLastName).frame(width: 148).multilineTextAlignment(.trailing)
                }
                
                HStack{
                    Label("Email", systemImage: "at")
                    Spacer()
                    TextField("me@mail", text: $inputtedEmail).frame(width: 148).multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Label("Role", systemImage: "person")
                    Spacer()
                    Picker("", selection: $inputtedType){
                        Text("Crew Leader").tag(PersonType.crewLeader)
                        Text("Crew Member").tag(PersonType.crewMember)
                        Text("Guest Planter").tag(PersonType.guestPlanter)
                        Text("Supervisor").tag(PersonType.supervisor)
                        Text("Past Crew Member").tag(PersonType.pastCrewMember)
                    }
                }
                HStack {
                    Spacer()
                    
                    Button(action: addPerson){
                        Text("Add")
                    }
                    Spacer()
                }
            }
        
            Section("People"){
                if personStore.persons.isEmpty {
                    Text("No existing planters").foregroundColor(.gray)
                }
                
                ForEach(personStore.persons){ person in
                    HStack{
                        Text("\(person.fullName)")
                        Spacer()
                        Text("\(person.type.rawValue)").foregroundColor(.gray)
                    }
                }
                
            }
        }
        .navigationTitle("My Crew")
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("\(alertText.title)"),
                message: Text("\(alertText.message)")
            )
        }
    }
}

struct MyCrewView_Previews: PreviewProvider {
    static var previews: some View {
        MyCrewView(savePersons: {}).environmentObject(PersonStore())
    }
}
