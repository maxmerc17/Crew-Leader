//
//  PlanterReportView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-27.
//

import SwiftUI

struct PlanterReportView: View {
    @State var planter : Person
    
    @EnvironmentObject var tallyStore : TallyStore
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    // MARK: Text content
    var numPlantingDays_text : Int {
        return tallyStore.getNumPlantingDays(planter: planter)
    }
    
    var average_text : Int {
        return tallyStore.getPlanterAverage(planter: planter) ?? 0 ///  ????
    }
    
    var record_text : Int {
        return tallyStore.getPlanterPB(planter: planter) ?? 0 /// ????
    }
    
    var total_text : Int {
        return tallyStore.getTotalTreesPlanted(planter: planter)
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView{
                PlanterProductionChartView(planter: planter).frame(width: g.size.width*0.95, height: g.size.height*0.6)//.border(.red)
                List {
                    Section("Report"){
                        HStack{
                            Text("Planting Days")
                            Spacer()
                            Text("\(numPlantingDays_text)")
                        }
                        HStack{
                            Text("Average")
                            Spacer()
                            Text("\(average_text)")
                        }
                        HStack{
                            Text("Personal Record")
                            Spacer()
                            Text("\(record_text)")
                        }
                        HStack {
                            Text("Season Total")
                            Spacer()
                            Text("\(total_text)")
                        }
                    }
                }.scrollDisabled(true).frame(minHeight: minRowHeight*5)
            }
        }.navigationTitle("\(planter.firstName)'s Report")
    }
}

import Charts

struct PlanterProductionChartView: View {
    @State var planter: Person
    
    @State var productionData : [(day: String, trees: Int)] = []
    
    @State var noDataToView : Bool = false
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateProductionData() {
        productionData = tallyStore.getTreesPerDay(planter: planter)
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
                            y: .value("Trees Planted", item.trees)
                            
                        ).annotation{
                            Text("\(item.trees)").font(.caption2)
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

struct PlanterReportView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterReportView(planter: Person.sampleData[0])
    }
}

