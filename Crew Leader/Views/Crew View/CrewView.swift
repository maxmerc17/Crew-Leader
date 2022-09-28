//
//  CrewView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-22.
//

import SwiftUI

struct CrewView: View {
    @EnvironmentObject var personStore: PersonStore
    @EnvironmentObject var tallyStore: TallyStore
    
    var body: some View {
        NavigationView {
            ScrollView{
                ChartContainerView()
                List{
                    Section("Report") {
                        HStack{
                            Text("Planting Days")
                            Spacer()
                            Text("\(tallyStore.getNumPlantingDays()) days")
                        }
                        HStack{
                            Text("Crew Average")
                            Spacer()
                            Text("\(tallyStore.getCrewAverage()) trees / day")
                        }
                        HStack{
                            Text("Crew Record")
                            Spacer()
                            Text("\(tallyStore.getCrewPB()) trees")
                        }
                        HStack{
                            Text("Season Total")
                            Spacer()
                            Text("\(tallyStore.getSeasonTotal()) trees")
                        }
                    }
                    Section("Planter Reports"){
                        ForEach(personStore.getCrew()){ member in
                            NavigationLink(destination: PlanterReportView(planter: member)) {
                                HStack{
                                    //Text("\(member.fullName)")
                                    Label("\(member.fullName)", systemImage: "person")
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                }.scrollDisabled(true).navigationTitle("My Crew").frame(height: 600)
            }
        }
    }
}

struct ChartContainerView: View {
    @State var charts : [String] = ["Production", "Allocation"]
    @State var selectedChart : String = "Production"
    
    func chartChanged(new chart: String) {
        selectedChart = chart
    }
    
    var body: some View {
        VStack{
            VStack{
                switch selectedChart {
                    case "Production": ProductionChartView()
                    case "Allocation": Text("hello")
                    default: Text("bye")
                }
            }.frame(width: 350, height: 270)
            
            HStack(spacing: 25) {
                ForEach(charts, id: \.self) { chart in
                    Button {
                        chartChanged(new: chart)
                    } label: {
                        HStack {
                            Text("\(chart)")
                        }.font(.system(size: 15))
                            .foregroundColor(chart == selectedChart
                                ? .accentColor
                                : .gray)
                    }
                }
            }.padding()
        }
    }
}

import Charts

struct ProductionChartView: View {
    @State var productionData : [(day: String, production: Int)] = []
    
    @State var noDataToView : Bool = false
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateProductionData() {
        productionData = tallyStore.getProductionPerDay()
        if productionData.isEmpty{
            noDataToView = true
        }
    }
    
    var body: some View {
            VStack {
                if productionData.isEmpty{
                    if (noDataToView) {
                        VStack{
                            Text("There is currently no crew data to view.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                            Text("Data may be taking longer to load. Or no tallies have been submitted.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                        }.padding()
                    }
                    Button(action: updateProductionData){
                        Label("Reload", systemImage: "arrow.clockwise")
                    }
                } else {
                    Text("Daily Production").font(.title3).padding()
                    Chart{
                        ForEach(productionData, id: \.day){ item in
                            BarMark(
                                x: .value("Day", item.day),
                                y: .value("Trees Planted", item.production)
                            ).annotation{
                                Text("\(item.production)").font(.caption2)
                            }
                        }
                    }
                }
            }.padding()
            .onAppear(){
            updateProductionData()
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
