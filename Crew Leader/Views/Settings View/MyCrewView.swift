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
    
    @State var isShowingSaveAlert : Bool = false
    
    func validate() -> Bool {
        if inputtedFirstName.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for first name."
            isShowingAlert = true
            return false
        }
        if inputtedLastName.isEmpty {
            alertText.title = "Improper Input"
            alertText.message = "Enter a value for last name."
            isShowingAlert = true
            return false
        }
        
        if let _ = personStore.getCrewLeader(), inputtedType == .crewLeader {
            alertText.title = "Invalid Input"
            alertText.message = "There is already a crew leader."
            isShowingAlert = true
            return false
        }
        let fullName = inputtedFirstName + " " + inputtedLastName
        if let _ = personStore.getPlanter(fullName: fullName) {
            alertText.title = "Invalid Input"
            alertText.message = "There is already a person with the same first and last name. Please update your first name or last name to make it unique. Recommended to update first name with an additional _."
            isShowingAlert = true
            return false
        }
        
        return true
    }
    
    func add_person() {
        let newPerson = Person(firstName: inputtedFirstName, lastName: inputtedLastName, email: inputtedEmail, type: inputtedType)
        personStore.persons.append(newPerson)
        savePersons()
        
        inputtedFirstName = ""
        inputtedLastName = ""
        inputtedType = PersonType.crewMember
    }
    
    func updatePerson() {
        self.PageState = UpdateState
        return
    }
    
    private enum Field: Int, CaseIterable { case username, password, third, fourth } // case names are random. its the function that counts
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form{
            Text("Reminder: Don't fuck it up. You cannot delete or update a crew member.").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
            Section("Input New Person"){
                HStack{
                    Label("First Name", systemImage: "textformat")
                    Spacer()
                    TextField("John", text: $inputtedFirstName).frame(width: 148).multilineTextAlignment(.trailing).focused($focusedField, equals: .username)
                }
                HStack{
                    Label("Last Name", systemImage: "textformat")
                    Spacer()
                    TextField("Smith", text: $inputtedLastName).frame(width: 148).multilineTextAlignment(.trailing).focused($focusedField, equals: .password)
                }
                
                HStack {
                    Label("Role", systemImage: "person")
                    Spacer()
                    Picker("", selection: $inputtedType){
                        Text("Crew Leader").tag(PersonType.crewLeader)
                        Text("Crew Member").tag(PersonType.crewMember)
                        Text("Guest Planter").tag(PersonType.guestPlanter)
                    }
                }
                HStack {
                    Spacer()
                    
                    Button(action: { if validate(){ isShowingSaveAlert = true } }){
                        Text("Save")
                    }.alert(isPresented: $isShowingSaveAlert) {
                        Alert(
                            title: Text("Add Crew Member?"),
                            message: Text("You cannot update or delete a member later"),
                            primaryButton: .default(Text("Yes! Add.")) {
                                add_person()
                            },
                            secondaryButton: .cancel()
                        )
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Close Keyboard") {
                    focusedField = nil
                }
            }
        }
    }
}

struct MyCrewView_Previews: PreviewProvider {
    static var previews: some View {
        MyCrewView(savePersons: {}).environmentObject(PersonStore())
    }
}
