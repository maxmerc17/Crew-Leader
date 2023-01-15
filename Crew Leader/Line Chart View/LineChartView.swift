//
//  LineChartView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-05.
//

import SwiftUI

struct LineChartView<Val: Conforming>: View {
    
    // MARK: Input
    var title : String? // chart title
    var xaxisLabel : String? // x axis label
    var yaxisLabel : String? // y axis label
    @Binding var xyData: [(x: String, y: Val)] // xy data
    
    // MARK: Output
    @State var w : W = W() // window
    @State var pointArray : PointArray<Val> = PointArray() // xy data mapped to a point array object
    
    // MARK: Control
    func map_Data_to_array_of_objects() { // onAppear
        pointArray.update(xyData: xyData)
        pointArray.setPosition(w: w)
    }
    
    @State var zoom : Double = 5
    func changeZoom(_ newZoom: Double) {
        pointArray.numVisable = Int(newZoom)
        pointArray.setPosition(w: w)
    }
    
    // MARK: Rendering
    var body: some View {
        GeometryReader { g in
            let minDim = min(g.size.width, g.size.height)
            
            let SW : CGFloat = pointArray.ScaleWidth() // scale width
            let CH = minDim * 0.8 // chart height
            let CW = ( g.size.width * 0.9 ) - SW // chart width
            let O = CGPoint(x: g.size.width * 0.1, y: minDim * 0.9) /// origin
            
            let _ : () = w.update(W: CW, H: CH, O: O, SW: SW)
            VStack{
                ChartContentView<Val>(w: $w, pointArray: $pointArray)
                    .frame(width: g.size.width, height: minDim).border(.blue)
                
                if !pointArray.points.isEmpty {
                    Slider(value: $zoom, in: 1...Double(pointArray.count+2), step: 1) {
                        Text("Length")
                    }.frame(width: w.W*0.6).onChange(of: zoom){ newZoom in
                        changeZoom(newZoom)
                    }
                }
                
            }
            
            
        }.onAppear(){
            map_Data_to_array_of_objects()
        }.onChange(of: w){ newW in
            pointArray.setPosition(w: newW)
        }
    }
}

struct ChartContentView<Val : Conforming> : View {
    @Binding var w : W
    @Binding var pointArray : PointArray<Val>
    @State var selectedPoint : UUID? = nil
    
    var body: some View {
        ZStack {
            ChartView<Val>(w: $w, pointArray : $pointArray)
            ControlView<Val>(w: $w, pointArray: $pointArray)
            LineView<Val>(w: $w, pointArray: $pointArray, selectedPoint: $selectedPoint)
        }.background().onTapGesture {
            selectedPoint = nil
        }.onLongPressGesture {
            print("Long pressed")
            
        }
    }
}

struct ChartView<Val: Conforming> : View {
    @Binding var w : W
    @Binding var pointArray : PointArray<Val>
    
    var body: some View {
        let CH = w.H /// chart height
        let CW = w.W /// chart width
        let O = w.O /// origin
        let SW = w.SW
        ZStack {
            /// x axis
            Path { path in
                path.move(to: CGPoint( x: O.x, y: O.y ))
                path.addLine(to: CGPoint( x: O.x + CW, y: O.y ))
            }.stroke(.gray)
            /// y axis
            Path { path in
                path.move(to: CGPoint( x: O.x + CW , y: O.y ))
                path.addLine(to: CGPoint( x: O.x + CW, y: O.y - CH ))
            }.stroke(.gray)
            /// dotted lines
            Path { path in
                path.move(to: CGPoint(x: O.x, y: O.y-CH*0.25))
                path.addLine(to: CGPoint(x: O.x+CW, y: O.y-CH*0.25))
            }.strokedPath(StrokeStyle(dash: [3])).foregroundColor(.gray)
            Path { path in
                path.move(to: CGPoint(x: O.x, y: O.y-CH*0.5))
                path.addLine(to: CGPoint(x: O.x+CW, y: O.y-CH*0.5))
            }.strokedPath(StrokeStyle(dash: [3])).foregroundColor(.gray)
            Path { path in
                path.move(to: CGPoint(x: O.x, y: O.y-CH*0.75))
                path.addLine(to: CGPoint(x: O.x+CW, y: O.y-CH*0.75))
            }.strokedPath(StrokeStyle(dash: [3])).foregroundColor(.gray)
            Path { path in
                path.move(to: CGPoint(x: O.x, y: O.y-CH))
                path.addLine(to: CGPoint(x: O.x+CW, y: O.y-CH))
            }.strokedPath(StrokeStyle(dash: [3])).foregroundColor(.gray)
            
            let SV = pointArray.ScaleVals() /// scale values
            Text("\(SV[0])").scaleItem().position(x: O.x + CW + SW/2, y: O.y - CH*0.25)
            Text("\(SV[1])").scaleItem().position(x: O.x + CW + SW/2, y: O.y - CH*0.5)
            Text("\(SV[2])").scaleItem().position(x: O.x + CW + SW/2, y: O.y - CH*0.75)
            Text("\(SV[3])").scaleItem().position(x: O.x + CW + SW/2, y: O.y - CH)
        }
    }
}

struct ControlView<Val: Conforming> : View {
    @Binding var w : W
    @Binding var pointArray: PointArray<Val>
    
    var body: some View{
        ZStack {
            if pointArray.visableSet < pointArray.numSets {
                Button(action: { pointArray.increment() }) {
                    Image(systemName: "arrow.right").frame(width: 40)
                }.position(x: w.O.x + w.W*0.95, y: w.O.y - w.H/2)
            }
            if 1 < pointArray.visableSet {
                Button(action: { pointArray.decrement() }) {
                    Image(systemName: "arrow.left")
                }.position(x: w.O.x + w.W*0.03, y: w.O.y - w.H/2)
            }
        }
        
    }
}

struct LineView<Val : Conforming>: View {
    @Binding var w : W
    @Binding var pointArray : PointArray<Val>
    @Binding var selectedPoint: UUID?
    
    
    var body: some View {
        ZStack {
            //ConnectionsView<Val>(pointArray: $pointArray)
            ForEach($pointArray.points, id: \.id) { $point in
                if point.visable {
                    PointView(p: $point, selectedPoint: $selectedPoint, w: $w)
                }
                
            }
        }
    }
}

struct PointView<Val: Conforming>: View {
    @Binding var p : Point<Val>
    @Binding var selectedPoint : UUID?
    @Binding var w: W
    
    var isSelectedPoint : Bool  {
        selectedPoint == p.id
    }
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: p.posX, y: w.O.y))
                path.addLine(to: p.position )
            }.strokedPath(StrokeStyle(dash: [3])).foregroundColor(.blue)
            
            Circle()
                .frame(width: isSelectedPoint ? 20 : 10)
                .foregroundColor(.blue).position(x: p.posX, y: p.posY)
                .onTapGesture { selectedPoint = p.id }
            
            var dim : CGFloat = isSelectedPoint ? 100 : 30
            
            Text("\(p.x)")
                .background(.ultraThickMaterial).opacity(0.75)
                .frame(width: dim, height: 30)
                .font(isSelectedPoint ? .headline : .caption)
                .foregroundColor(isSelectedPoint ? .blue : .gray)
                .position(x: isSelectedPoint ? p.posX : p.posX,
                          y: isSelectedPoint ? w.O.y : w.O.y + 20)
                
            
//            if isSelectedPoint {
//                Text("\(p.y.toString())")
//                    .frame(width: 70, height: 30)
//                    .font(.headline)
//                    .foregroundColor(.blue)
//                    .position(x: w.O.x + w.W + w.SW/2, y: p.posY)
//            }
            
            
            if isSelectedPoint {
                VStack{
                    //Text("\(p.x),")
                    Text("\(p.y.toString())").foregroundColor(.blue)
                }.pointDetail().position(x: p.posX-35, y: p.posY)
            }
        }
    }
                  
}

struct ConnectionsView<Val: Conforming> : View {
    @Binding var pointArray: PointArray<Val>

    var body: some View {
        ZStack {
            if pointArray.points.count > 1 {
                let firstVisableIndex = pointArray.numVisable*(pointArray.visableSet-1)
                Path { p in
                    p.move(to: pointArray.points[firstVisableIndex].position)
                    for i in firstVisableIndex+1..<firstVisableIndex+10 {
                        if i < pointArray.points.count { // prolly not the best way to check index in bounds
                            p.addLine(to: pointArray.points[i].position)
                        }
                    }
                }.stroke(.blue, lineWidth: 1)
            }
        }
    }
}

 
struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView<Int>(xyData: .constant([
            (x: "one", y: 1),
            (x: "two", y: 1),
            (x: "three", y: 1),
            (x: "four", y: 1),
            (x: "five", y: 125 )
        ])).frame(width: 390)
    }
}
