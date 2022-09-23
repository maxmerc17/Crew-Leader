//
//  PieChartView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-20.
//

import SwiftUI

struct PieChartView: View {
    @Binding var pieChartParameters : PieChartParameters
    @Binding var selectedSlice : Slice?
    
    var body: some View {
        HStack{
            ZStack{
                ForEach($pieChartParameters.slices){ $slice in
                    SliceView(radius: $pieChartParameters.radius,
                              slice: $slice,
                              selectedSlice: $selectedSlice)
                }
                
//                if pieChartParameters.slices.last == nil || pieChartParameters.slices.last!.endAngle < .pi*2 {
//
//                    SliceView(radius: $pieChartParameters.radius,
//                              slice: .constant(Slice(name: "Remaining",
//                                                     value: pieChartParameters.total - pieChartParameters.slices.reduce(0) { tot, slice in tot + slice.value },
//                                                     total: pieChartParameters.total, color: .gray,
//                                                     startAngle: (pieChartParameters.slices.last == nil) ? 0 :  pieChartParameters.slices.last!.endAngle ,
//                                                     endAngle: .pi*2 )),
//                              selectedSlice: $selectedSlice)
//                }
                
                GeometryReader { geometry in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    let centerX = width/2
                    let centerY = height/2
                    Path { path in
                        path.move(to: CGPoint(
                            x: centerX,
                            y: centerY
                        ))

                        path.addArc(center: CGPoint(x: centerX, y: centerY),
                                    radius: CGFloat(pieChartParameters.radius-10), // radius
                                    startAngle: Angle(radians: 0), // start angle
                                    endAngle: Angle(radians: 2*(.pi)), // endangle
                                    clockwise: false)

                    }.foregroundColor(.white)
                    VStack(alignment: .center){
                        if selectedSlice != nil {
                            Text("\(selectedSlice!.name)").font(.title3).bold().frame(width: CGFloat(pieChartParameters.radius))
                            Text("\(selectedSlice!.value) \(pieChartParameters.dataType)").font(.caption2)
                            Text("\(utilities.formatFloat(float: selectedSlice!.percent*100))%").font(.caption2)
                        }
                        else {
                            Text("\(pieChartParameters.title)").font(.title3).bold()
                        }
                    }.multilineTextAlignment(.center)
                    .frame(width: CGFloat(pieChartParameters.radius), height: CGFloat(pieChartParameters.radius), alignment: .center)
                    .position(x: centerX, y: centerY).font(.title)
                    .onTapGesture {
                        selectedSlice = nil
                    }
                }
                
            }.frame(width: 200, height: 200)
            ScrollView{
                VStack(alignment: .leading) {
                    ForEach(pieChartParameters.slices){ slice in
                        HStack(alignment: .top){
                            RoundedRectangle(cornerRadius: 2).frame(width: 10, height: 10).foregroundColor(slice.color)
                            VStack {
                                Text("\(slice.name) ").font(.caption)
                                Text("\(slice.value) trees").font(.caption)
                            }
                        }
                    }
                }
            }.frame(width: 100, height: 200)
        }
    }
}

struct SliceView: View {
    @Binding var radius : Int
    @Binding var slice : Slice
    @Binding var selectedSlice : Slice?
    
    var getRadius : CGFloat {
        if selectedSlice == slice {
            return CGFloat(radius + 10)
        } else {
            return CGFloat(radius)
        }
    }
    
    let shift : Double = (.pi)/2
    let buffer : Double = (.pi)/90
    var getStartAngle : Angle {
        if selectedSlice == slice {
            if slice.startAngle-shift + buffer > slice.endAngle-shift - buffer {
                return Angle(radians: slice.startAngle-shift)
            } else {
                return Angle(radians: slice.startAngle-shift + buffer)
            }
            
        } else {
            return Angle(radians: slice.startAngle-shift)
        }
    }
    
    var getEndAngle : Angle {
        if selectedSlice == slice {
            if slice.startAngle-shift + buffer > slice.endAngle-shift - buffer {
                return Angle(radians: slice.endAngle-shift)
            } else {
                return Angle(radians: slice.endAngle-shift - buffer)
            }
            
        } else {
            return Angle(radians: slice.endAngle-shift)
        }
    }
    
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    let centerX = width/2
                    let centerY = height/2
                    
                    path.move(to: CGPoint(
                        x: centerX,
                        y: centerY
                    ))
                    
                    path.addArc(center: CGPoint(x: centerX, y: centerY),
                                radius: getRadius,
                                startAngle: getStartAngle,
                                endAngle: getEndAngle,
                                clockwise: false)
                    
                }.foregroundColor(slice.color)
            }
        }.onTapGesture {
            selectedSlice = slice
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(pieChartParameters:
                .constant(PieChartParameters(radius: 100,
                                             slices: [Slice(name: "Item 1", value: 2, total: 10, color: .blue), Slice(name: "Item 2", value: 4, total: 10, color: .red), Slice(name: "Item 3", value: 3, total: 10, color: .yellow)],
                                             title: "Pie Chart Title",
                                             dataType: "trees",
                                             total: 10)), selectedSlice: .constant(nil))
    }
}



