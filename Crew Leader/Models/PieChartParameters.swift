////
////  PieChartParameters.swift
////  Crew Leader
////
////  Created by Max Mercer on 2022-09-20.
////
//import Foundation
//import SwiftUI
//
//struct PieChartParameters {
//    var radius: Int
//    var slices: [SliceHeader]
//    var title: String
//    var dataType: String
//    var total: Int
//    
//    init(radius: Int, slices: [slices], title: String, dataType: String, total: Int) {
//        self.radius = radius
//        self.sliceHeaders = slices
//        self.title = title
//        self.dataType = dataType
//        self.total = total
//    }
//}
//
//
//
//
//struct Slice: Identifiable, Equatable {
//    var id : UUID
//    var name : String
//    var value : Int
//    var total : Int
//    var color : Color
//    
//    var startAngle : Double
//    var endAngle : Double
//    
//    var percent : Float {
//        Float(value)/Float(total)
//    }
//    
//    var angle : Double {
//        Double(2*(.pi)*percent)
//    }
//    
//    init(id: UUID = UUID(), name: String, value: Int, total: Int, color: Color) {
//        self.id = id
//        self.name = name
//        self.value = value
//        self.total = total
//        self.color = color
//    }
//}
//
//
////struct SliceHeader: Identifiable {
////    var id: UUID
////    var startAngle : Double
////    var endAngle : Double
////    var slice : Slice
////
////    init(id: UUID = UUID(), startAngle: Double, endAngle: Double, slice: Slice) {
////        self.id = id
////        self.startAngle = startAngle
////        self.endAngle = endAngle
////        self.slice = slice
////    }
////
////    init(id: UUID = UUID(), slice: Slice){
////        self.id = id
////        self.slice = slice
////        self.startAngle = 0
////        self.endAngle = 0
////    }
////}
//
//
