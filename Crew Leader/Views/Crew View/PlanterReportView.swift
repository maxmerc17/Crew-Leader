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
                PlanterProductionChartView(planter: planter).frame(width: g.size.width*0.95, height: g.size.height*0.8)//.border(.red)
                List {
                    Section("Report"){
                        HStack{
                            Text("Planting Days")
                            Spacer()
                            Text("\(numPlantingDays_text) days")
                        }
                        HStack{
                            Text("Average")
                            Spacer()
                            Text("\(average_text) trees / day")
                        }
                        HStack{
                            Text("Personal Record")
                            Spacer()
                            Text("\(record_text) trees")
                        }
                        HStack {
                            Text("Season Total")
                            Spacer()
                            Text("\(total_text) trees")
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
    
    @State var productionData : [(x: String, y: Int)] = []
    
    @State var noDataToView : Bool = false
    
    @EnvironmentObject var tallyStore : TallyStore
    
    func updateProductionData() {
        let receiver = tallyStore.getTreesPerDay(planter: planter)
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
                Text("Daily Production").font(.title3).padding()
                LineChartView<Int>(xyData: $productionData, w: W(W: 300, H: 260, O: CGPoint(x: 15,y: 250), SW: 50))
                /*Chart{
                    ForEach(productionData, id: \.day){ item in
                        BarMark(
                            x: .value("Day", item.day),
                            y: .value("Trees Planted", item.trees)
                            
                        ).annotation{
                            Text("\(item.trees)").font(.caption2)
                        }
                    }
                }*/
            }
        }.frame(width: 350, height: 335)
            .padding()
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

