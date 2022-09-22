//
//  CrewView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-22.
//

import SwiftUI

struct CrewView: View {
    @EnvironmentObject var personStore: PersonStore
    
    var body: some View {
        NavigationView {
            List{
                ChartView().frame(width: 350, height: 270)
                .background(.gray)
            
                Section("Report") {
                    HStack{
                        Text("Season Total")
                        Spacer()
                        Text("467,321")
                    }
                    HStack{
                        Text("Crew PB")
                        Spacer()
                        Text("17,398")
                    }
                    HStack{
                        Text("Crew Average")
                        Spacer()
                        Text("12,562")
                    }
                    HStack{
                        Text("Planting days")
                        Spacer()
                        Text("45")
                    }
                }
                Section("Planter Reports"){
                    ForEach(personStore.getCrew()){ member in
                        NavigationLink(destination: {}) {
                            HStack{
                                Text("\(member.fullName)")
                                Spacer()
                            }
                        }
                    }
                    
                }
            }.navigationTitle("Crew")
        }
    }
}

struct ChartView: View {
    var body: some View {
        VStack{
            Text("Chart area")
        }
    }
}

//var demoStore = PersonStore()
//demoStore.persons = Person.sampleData
struct CrewView_Previews: PreviewProvider {
    static var previews: some View {
        CrewView().environmentObject(PersonStore())
    }
}
