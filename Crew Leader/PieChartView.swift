//
//  PieChartView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-20.
//


import SwiftUI

struct PieChartView: View {
    @State var radius : Int
    @State var slices : [Slice]
    @State var centerTextTitle: String
    @State var dataType : String
    
    @State var selectedSlice : Slice? = nil
    
    @State var sliceHeaders : [SliceHeader] = []
    
    func updateSliceHeaders() {
        var startAngle : Double = 0
        var endAngle : Double = 0
        for slice in slices {
            endAngle = startAngle + slice.angle
            var newSliceHeader = SliceHeader(startAngle: startAngle, endAngle: endAngle, slice: slice)
            sliceHeaders.append(newSliceHeader)
            startAngle = endAngle
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                ForEach(sliceHeaders){ sliceHeader in
                    SliceView(radius: radius,
                              startAngle: sliceHeader.startAngle,
                              endAngle: sliceHeader.endAngle,
                              slice: sliceHeader.slice,
                              selectedSlice: $selectedSlice)
                }
                
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
                                    radius: CGFloat(140), // radius
                                    startAngle: Angle(radians: 0), // start angle
                                    endAngle: Angle(radians: 2*(.pi)), // endangle
                                    clockwise: false)

                    }.foregroundColor(.white)
                    VStack{
                        if selectedSlice != nil {
                            Text("\(selectedSlice!.name)")
                            Text("\(selectedSlice!.value) \(dataType)").font(.caption)
                        }
                        else {
                            Text("\(centerTextTitle)")
                        }
                    }.position(x: centerX, y: centerY).font(.title)
                }
                
            }
            VStack(alignment: .trailing){
                ForEach(slices){ slice in
                    HStack{
                        RoundedRectangle(cornerRadius: 2).frame(width: 20, height: 10).foregroundColor(slice.color)
                        Text("\(slice.name) -").font(.title3)
                        Text("\(slice.value) trees").font(.caption)
                    }
                }
            }
            
        }.onAppear(){
            updateSliceHeaders()
        }
        
    }
}

struct SliceView: View {
    @State var radius : Int
    @State var startAngle : Double
    @State var endAngle : Double
    @State var slice : Slice
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
            return Angle(radians: startAngle-shift + buffer)
        } else {
            return Angle(radians: startAngle-shift)
        }
    }
    
    var getEndAngle : Angle {
        if selectedSlice == slice {
            return Angle(radians: endAngle-shift - buffer)
        } else {
            return Angle(radians: endAngle-shift)
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


struct Slice: Identifiable, Equatable {
    var id : UUID
    var name : String
    var value : Int
    var total : Int
    var color : Color
    
    var percent : Float {
        Float(value)/Float(total)
    }
    
    var angle : Double {
        Double(2*(.pi)*percent)
    }
    
    init(id: UUID = UUID(), name: String, value: Int, total: Int, color: Color) {
        self.id = id
        self.name = name
        self.value = value
        self.total = total
        self.color = color
    }
}

struct SliceHeader: Identifiable {
    var id: UUID
    var startAngle : Double
    var endAngle : Double
    var slice : Slice
    
    init(id: UUID = UUID(), startAngle: Double, endAngle: Double, slice: Slice) {
        self.id = id
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.slice = slice
    }
}




struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(radius: 150, slices: [Slice(name: "Item 1", value: 2, total: 10, color: .blue), Slice(name: "Item 2", value: 4, total: 10, color: .red), Slice(name: "Item 3", value: 3, total: 10, color: .yellow)], centerTextTitle: "Pie Chart", dataType: "trees")
    }
}


