//
//  CreatePartialView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

import SwiftUI

struct CreatePartialView: View {
    @Binding var isPresentingCreatePartialView : Bool
    
    @Environment(\.dismiss) private var dismiss
    
    func onOkay() {
        dismiss()
    }
    
    func onDiscard(){
        dismiss()
    }
    
    var body: some View {
        ZStack {
            Color.gray.frame(width: 350, height: 700).cornerRadius(45).opacity(0.7) //UIScreen.main.bounds.size.height*0.90
            VStack{
                HStack{
                    Button(action: onOkay ) {
                        Text("Save   ").padding().background(.white).foregroundColor(.black)
                    }.cornerRadius(45)
                    Button(action: onDiscard ) {
                        Text("Discard").padding().background(.white).foregroundColor(.black)
                    }.cornerRadius(45)
                }
                
            }.padding()
        }
    }
}

struct CreatePartialView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePartialView(isPresentingCreatePartialView: .constant(true))
    }
}
