//
//  DeveloperNotesView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2023-05-09.
//

import SwiftUI

struct DeveloperNotesView: View {
    var body: some View {
        ScrollView{
            Text("Crew Wut??").font(.title)
            Text("Whaddup whaddup!! Welcome to Crew Leader 0.1 BANG BANG!! If you're looking for a hype tree planting application filled with convienent tools and infested with bugs (wait .. what?) then you have come to the right place! Crew Leader is for Crew Leaders made by a past Crew Leader. Crew Leader consists of 4 modules: Cache Calculator, Blocks, Tallies, and Crew.").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
            
            Text("Start by going to settings and adding crew members and species. Then add your first block. Once crew members, species, at least one block, and at least two tallies are created the entire application will be accessible. Try clicking on the charts to view additional features. And play around to learn how everything works.").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
            
            Text("The application lacks many delete and update functionalities. You cannot update/delete crew members, species, or blocks. You also cannot update tallies, only delete. So the user is required to have 'baller-like' accuracy. And, as Ru Paul would say ... don't fuck it up!").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
            
            Text("Disclaimer, this application is not complete, it is not tested, and it is certainly scrapy-doo. So do not rely on the data in this application. If the application returns false information, stops working, melts the battery in your phone, or summons a sleuth of black bears to your block, I neglect all responsibility. However if you would like to report any bugs or supply any suggestions please contact me at maxmercer36@gmail.com :)").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
            
            Text("... Alright! Well let's get to it. Everyone out of the truck, we've got a fuck-load of trees to plant.").font(.custom(
                "AmericanTypewriter",
                fixedSize: 16)).padding()
        }
    }
}

struct DeveloperNotesView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperNotesView()
    }
}
