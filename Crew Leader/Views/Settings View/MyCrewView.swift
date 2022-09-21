//
//  MyCrewView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-21.
//

import SwiftUI

struct MyCrewView: View {
    //let savePerson: () -> Void
    
    @EnvironmentObject var personStore : PersonStore
    
    @State var inputtedFirstName: String = ""
    @State var inputtedLastName: String = ""
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    func addPerson() {
        
    }
    
    var body: some View {
        VStack{
            Form{
                Section("Input New Person"){
                    HStack{
                        Label("First Name:", systemImage: "textformat")
                        Spacer()
                        TextField("ex. John", text: $inputtedFirstName).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Label("Last Name:", systemImage: "textformat")
                        Spacer()
                        TextField("ex. Smith", text: $inputtedLastName).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Spacer()
                        Button(action: addPerson){
                            Text("Add")
                        }
                        Spacer()
                    }
                }
            
                Section("Existing Species"){
                    if personStore.persons.isEmpty {
                        Text("No existing planters").foregroundColor(.gray)
                    }
                    
                    ForEach(personStore.persons){ person in
                        HStack{
                            
                        }
                    }
                }
            }
        }
        .navigationTitle("Species List")
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
        MyCrewView().environmentObject(PersonStore())
    }
}
