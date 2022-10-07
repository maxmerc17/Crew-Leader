//
//  LineChartView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-05.
//

import SwiftUI

protocol Conforming{
    func toString() -> String
    
}
extension Int: Conforming {
    func toString() -> String {
        String(self)
    }
}
extension Float: Conforming {
    func toString() -> String {
        String(self)
    }
}
extension Double: Conforming {
    static func convert(_ number: Conforming) -> Double {
        if let intNum = number as? Int {
            return Double(intNum)
        } else if let floatNum = number as? Float {
            return Double(floatNum)
        } else if let doubleNum = number as? Double {
            return Double(doubleNum)
        } else {
            return 0.0
        }
    }
    func toString() -> String {
        String(self)
    }
}

extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.#E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    static let display : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    }()
}
extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
    
    var displayFormatted : String {
        return Formatter.display.string(for: self) ?? ""
    }
}

struct ScaleItem : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.gray)
    }
}
struct PointDetail : ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.headline)
            .foregroundColor(.gray)
            .padding(2)
            .background(.ultraThickMaterial).opacity(0.75)
            .cornerRadius(10)
    }
}
extension View {
    func scaleItem() -> some View {
        modifier(ScaleItem())
    }
    func pointDetail() -> some View {
        modifier(PointDetail())
    }
}

struct Point<T: Conforming>: Identifiable {
    
    var id: UUID = UUID()
    var x: String
    var y: T
    var dubY: Double {
        Double.convert(y)
    }
    
    var posX : CGFloat = 0
    var posY : CGFloat = 0
    var visable : Bool = false
    
    var position : CGPoint {
        CGPoint(x: posX, y: posY)
    }
}



struct PointArray<Val: Conforming> {
    var points : [Point<Val>]
    var count : Int {
        points.count
    }
    
    var maxPoint : Point<Val>? {
        guard !points.isEmpty else { return nil }
        
        return points.max(by: { a, b in a.dubY < b.dubY } )
    }
    var minPoint : Point<Val>? {
        guard !points.isEmpty else { return nil }
        
        return points.min(by: { a, b in a.dubY < b.dubY })
    }
    var yAxisMax : Double? {
        guard !points.isEmpty else { return nil }
        
        if let mp = maxPoint {
            let order = floor(log10(mp.dubY)) // ex 100 -> order 2, 6 -> order 0, 9 -> order 0
            
            let n = 1*pow(10, order) // ex n = 100 , n = 1, n = 1
            let n_1 = (order == 0) ? 0 : pow(10, order - 1) // ex n_1 = 10 , n_1 = 0, n_1 = 0
            
            let placeValues = ( order <= 1 ? [0] : [1, 2, 5, 8] )
            
            for j in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] {
                let dj = Double(j)
                for i in placeValues {
                    let di = Double(i)
                    let maxVal = ( dj * n ) + ( di * n_1 ) // ex maxVal = 100
                    
                    if Int(maxVal) % 4 == 0 && mp.dubY <= maxVal { /// maxVal will always be Integer
                        return maxVal // ex 100
                    }
                }
            }
            return pow(10, order + 1)
        }
        return nil
    }
    
    var numVisable = 10
    
    init() {
        self.points = []
    }
    
    mutating func update(xyData: [(x: String, y: Val)]){
        let points = xyData.map { x, y in Point<Val>(x: x, y: y) }
        self.points = points
    }
    mutating func setPosition(w: W) {
        guard !points.isEmpty else {
            return
        }
        
        let start = w.O.x + w.W*0.05
        let end = w.O.x + w.W*0.95
        let buffer = (end - start) / CGFloat(min(points.count-1, numVisable))
        
        let scale = w.H / CGFloat(yAxisMax!)
        
        for i in 0..<points.count {
            points[i].posX = start + ( CGFloat(i % numVisable) * buffer )
            points[i].posY = w.O.y - ( points[i].dubY * scale )
            points[i].visable = i < numVisable ? true : false
        }
    }
    
    func ScaleVals() -> [String] { /// returns values for scale that will be displayed. If yAxisMax is nil it returns ["3", "6", ... ]
        if let yam = yAxisMax {
            let order = floor(log10(yam))
            if order < 6 {
                return [ (yam*0.25).displayFormatted,
                         (yam*0.5).displayFormatted,
                         (yam*0.75).displayFormatted,
                         (yam).displayFormatted ]
            } else {
                return [ (yam*0.25).scientificFormatted, (yam*0.5).scientificFormatted, (yam*0.75).scientificFormatted, (yam).scientificFormatted ]
            }
        }
        return ["3", "6", "9", "12"]
    }
    func ScaleWidth() -> CGFloat {
        if let yam = yAxisMax {
           let order = floor(log10(yam))
           
            switch order {
                case 0...3 :
                    return 40
                case 4...10 :
                    return 50
                default :
                    return 70
            }
        }
        return 40
    }
    
    // MARK: Visability
    var numSets : Int {
        Int(ceil(Double(points.count) / Double(numVisable)))
    }
    
    var _visableSet : Int = 1
    var visableSet : Int {
        get {
            return _visableSet
        }
        set {
            guard newValue <= numSets && 0 < newValue else {
                return
            }
            _visableSet = newValue
            for i in 0..<points.count {
                points[i].visable = (newValue-1)*numVisable < i+1 && i+1 <= newValue*numVisable
            }
        }
    }
    mutating func increment() {
        visableSet += 1
    }
    mutating func decrement() {
        visableSet -= 1
    }
    
}

struct W: Equatable {
     var W : CGFloat
     var H : CGFloat
     var O : CGPoint
     var SW : CGFloat
    
    init(W: CGFloat, H: CGFloat, O: CGPoint, SW: CGFloat) {
        self.W = W
        self.H = H
        self.O = O
        self.SW = SW
    }
    
    init(){
        self.W = 0
        self.H = 0
        self.O = CGPoint(x: 0, y: 0)
        self.SW = 0
    }
    
    mutating func update(W: CGFloat, H: CGFloat, O: CGPoint, SW: CGFloat){
        self.W = W
        self.H = H
        self.O = O
        self.SW = SW
    }
}

struct LineChartView<Val: Conforming>: View {
    var title : String?
    var xaxisLabel : String?
    var yaxisLabel : String?
    @Binding var xyData: [(x: String, y: Val)]
    
    @State var w : W = W()
    @State var pointArray : PointArray<Val> = PointArray()
    
    func map_Data_to_array_of_objects() { // onAppear
        pointArray.update(xyData: xyData)
        pointArray.setPosition(w: w)
    }
    
    @State var zoom : Double = 5
    func changeZoom(_ newZoom: Double) {
        pointArray.numVisable = Int(newZoom)
        pointArray.setPosition(w: w)
    }
    
    var body: some View {
        GeometryReader { g in
            let minDim = min(g.size.width, g.size.height)
            let SW : CGFloat = pointArray.ScaleWidth() /// scale width
            let CH = minDim * 0.8 /// chart height
            let CW = minDim * 0.9 - SW /// chart width
            let O = CGPoint(x: minDim * 0.1, y: minDim * 0.9) /// origin
            
            let _ : () = w.update(W: CW, H: CH, O: O, SW: SW)
            VStack{
//                HStack{
//                    Spacer()
//                    Button(action: changeZoom){
//                        Image(systemName: "arrow.up.left.and.arrow.down.right")
//                    }
//                }
                
                ChartContentView<Val>(w: $w, pointArray: $pointArray)
                    .frame(width: minDim, height: minDim).border(.blue)
                
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
