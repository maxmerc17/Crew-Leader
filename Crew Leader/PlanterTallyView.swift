//
//  PlanterTallyView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-11.
//

import SwiftUI

struct PlanterTallyView: View {
    @State var Pli048_boxes : String = ""
    @State var Pli048_bundles : String = ""
    @State var Sx051_boxes : String = ""
    @State var Sx051_bundles : String = ""
    @State var total_bundles : Int = 5
    
    var body: some View {
        VStack {
            Form {
                Section("Pli048"){
                    TextField("Total Boxes Planted", text: $Pli048_boxes)
                    Section("Partials - \(total_bundles) bundles total"){
                    }
                }
                Section("Sx051"){
                    TextField("Boxes", text: $Sx051_boxes)
                    TextField("Bundles", text: $Sx051_bundles)
                }
            }
        }.navigationTitle("Tallies")
    }
}

struct PlanterTallyView_Previews: PreviewProvider {
    static var previews: some View {
        PlanterTallyView()
    }
}
