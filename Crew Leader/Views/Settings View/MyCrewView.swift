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
    
    @State var inputtedSpeciesCode: String = ""
    @State var inputtedTreesPerBox: String = ""
    @State var inputtedTreesPerBundle: String = ""
    
    @State var isShowingAlert = false
    @State var alertText = alertTextType()
    
    func addPerson() {
        
    }
    
    var body: some View {
        VStack{
            Form{
                Section("Input New Species"){
                    HStack{
                        Label("Species Code:", systemImage: "textformat")
                        Spacer()
                        TextField("ex. PLI048", text: $inputtedSpeciesCode).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Label("Trees Per Box", systemImage: "shippingbox")
                        Spacer()
                        TextField("ex. 420", text: $inputtedTreesPerBox).frame(width: 148).multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Label("Trees Per Bundle", systemImage: "pause.rectangle")
                        Spacer()
                        TextField("ex. 20", text: $inputtedTreesPerBundle).frame(width: 129).multilineTextAlignment(.trailing)
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
        MyCrewView()
    }
}
