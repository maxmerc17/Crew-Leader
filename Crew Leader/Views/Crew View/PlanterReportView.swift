//
//  PlanterReportView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-27.
//

import SwiftUI

struct PlanterReportView: View {
    @State var planter : Person
    
    var body: some View {
        NavigationView{
            ScrollView {
                PlanterProductionChartView(planter: planter)
            }.frame(height: 600).navigationTitle("\(planter.firstName)'s Report")
        }
    }
}

import Charts

struct PlanterProductionChartView: View {
    @State var planter: Person
    
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
                        Text("There is currently no planter data to view.").font(.headline).foregroundColor(.gray).multilineTextAlignment(.center)
                        Text("Data may be taking longer to load. Or no tallies have been submitted for this planter.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center)
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
                            Text("\(item.production) trees").font(.caption2)
                        }
                    }
                }
            }
        }.padding()
        .onAppear(){
        updateProductionData()
    }
}

struct PlanterReportView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterReportView(planter: Person.sampleData[0])
    }
}

