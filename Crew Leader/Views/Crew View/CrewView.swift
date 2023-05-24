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
                }.scrollDisabled(true).navigationTitle("My Crew").frame(height: 800)
            }
        }
    }
}

struct ChartContainerView: View {
    @State var charts : [String] = ["Production"] //"Allocation"
    @State var selectedChart : String = "Production"
    
    func chartChanged(new chart: String) {
        selectedChart = chart
    }
    
    var body: some View {
        VStack{
            VStack{
                switch selectedChart {
                    case "Production": ProductionChartView()
                    //case "Allocation": Text("Coming Soon!")
                    default: Text("Error displaying chart")
                }
            }.frame(width: 350, height: 350)
            
            /*HStack(spacing: 25) {
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
            }.padding()*/
        }
    }
}

import Charts

struct ProductionChartView: View {
    @State var productionData : [(x: String, y: Int)] = []
    
    @State var noDataToView : Bool = false
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateProductionData() {
        let receiver = tallyStore.getProductionPerDay()
        productionData = receiver.map { (day: String, production: Int) in
            (x: day, y: production)
        }
        if (productionData.count < 2) {
            noDataToView = true
        }
    }
    
    var body: some View {
            VStack {
                if productionData.count < 2{
                    if (noDataToView) {
                        VStack{
                            Text("Data taking longer to load, or less than 2 planting days have been completed. ").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center).padding()
                            Text("Complete 2 planting days of tallies or click retry to view this chart. ").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
                        }.padding()
                    }
                    Button(action: updateProductionData){
                        Label("Reload", systemImage: "arrow.clockwise")
                    }
                } else {
                    Text("Daily Production").font(.title3)
                    LineChartView<Int>(xyData: $productionData, w: W(W: 280, H: 210, O: CGPoint(x: 20,y: 210), SW: 50))
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    /*Chart{
                        ForEach(productionData, id: \.day){ item in
                            BarMark(
                                x: .value("Day", item.day),
                                y: .value("Trees Planted", item.production)
                            ).annotation{
                                Text("\(item.production)").font(.caption2)
                            }
                        }
                    }*/ // where you put the new chart'
                    
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
