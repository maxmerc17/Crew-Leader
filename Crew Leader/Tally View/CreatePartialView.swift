//
//  CreatePartialView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct CreatePartialView: View {
    @Binding var isPresentingCreatePartialView : Bool
    @Binding var partialData : Partial.Data
    
    @State var selectedSpecies : Species = Species(data: Species.Data())
    
    
    @Environment(\.dismiss) private var dismiss
    
    func onOkay() {
        isPresentingCreatePartialView = false
    }
    
    func onDiscard(){
        isPresentingCreatePartialView = false
    }
    
    var body: some View {
        ZStack {
            Color.gray.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height).opacity(0.7) //
            VStack{
                HStack{
                    Text("Species")
                    Picker("Species", selection: $selectedSpecies){
                        ForEach(Species.sampleData){
                            species in
                            Text("\(species.name)")
                        }
                    }
                }
                
                ForEach(Array(partialData.people), id: \.key){
                    planter, bundles in
                    RowView(planter: planter, bundles: bundles, partialData: $partialData)
                }
                
                HStack{
                    Button(action: onOkay ) {
                        Text("Save   ").padding().background(.white).foregroundColor(.black)
                    }.cornerRadius(45)
                    Button(action: onDiscard ) {
                        Text("Discard").padding().background(.white).foregroundColor(.black)
                    }.cornerRadius(45)
                }
                
            }.onAppear(){
                partialData.people[Person.sampleData[0]] = 0
                partialData.people[Person.sampleData[1]] = 0
            }
        }
    }
}

struct RowView: View {
    @State var planter : Person
    @State var bundles : Int
    @Binding var partialData : Partial.Data
    
    var body: some View {
        HStack{
            Picker("Planter", selection: $planter){
                ForEach(Crew.sampleData.members){
                    member in
                    Text("\(member.fullName)")
                }
            }
            Text("Planted ")
            Picker("Bundles", selection: $bundles){
                Text("0").tag(0)
                Text("1").tag(1)
                Text("2").tag(2)
            }
            Text("Bundles")
        }.padding()
    }
}

struct CreatePartialView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreatePartialView(isPresentingCreatePartialView: .constant(true), partialData: .constant(Partial.Data(species: Species.sampleData[0], people: [Person.sampleData[0] : 5, Person.sampleData[1] : 5])))
    }
}
