//
//  LineChartStyling.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-10-07.
//

import Foundation
import SwiftUI

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
