//
//  CreatePartialView.swift
//  Crew Leader
//
//  Created by Max Mercer on 2022-09-12.
//

// TODO: ensure default block and species is selected

import SwiftUI

struct CreatePartialView: View {
    @Binding var newTallyData : DailyTally
    @Binding var newPartialData : Partial
    
    @Binding var isPresentingCreatePartialView : Bool
    
    @State var selectedSpecies : Species
    @State var selectedBlock : String
    @State var selectedPlanter : Person
    
    @Binding var partials : [Partial]
    
    @State var isShowingError : Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var blockStore : BlockStore
    @EnvironmentObject var personStore : PersonStore
    
    var blockObjects : [Block]{
        newTallyData.blocks.keys.map({ blockString in blockStore.getBlock(blockName: blockString)!}) // !!
    }
    
    var totalBundlesClaimed : Int {
        get{
            newPartialData.totalBundlesClaimed
        }
        
    }
    
    func areAllBundlesClaimed() -> Bool {
        return ( totalBundlesClaimed == selectedSpecies.numBundles )
    }
    
    func onOkay() {
        // add verification
        if (areAllBundlesClaimed() && (newPartialData.people.count > 1)){
            newPartialData.species = selectedSpecies
            newPartialData.blockName = selectedBlock
            partials.append(newPartialData)
            newPartialData = Partial(data: Partial.Data())
            isPresentingCreatePartialView = false
        } else {
            isShowingError = true
        }
        
    }
    
    func onDiscard(){
        newPartialData = Partial(data: Partial.Data())
        isPresentingCreatePartialView = false
    }
    
    func addPerson() {
        let people = newPartialData.people.keys
        let newPerson = personStore.getCrew().first(where: {!people.contains($0)})
        if let newPerson {
            newPartialData.people[newPerson] = 0
        }
    }
    
    var body: some View {
        ZStack {
            //Color.gray.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height).opacity(0.7) //
            ScrollView{
                VStack {
                    Text("\(totalBundlesClaimed) / \(selectedSpecies.numBundles) bundles claimed").font(.headline)
                    if (selectedSpecies.numBundles > totalBundlesClaimed){
                        Text("\(selectedSpecies.numBundles - totalBundlesClaimed) left to claim").font(.caption)
                    }
                }.padding()
                    .foregroundColor( {
                        if areAllBundlesClaimed() {
                            return .green
                        } else { return .red }
                    }())
                
                VStack(alignment: .trailing){
                    HStack{
                        Text("Block:")
                        Picker("Blocks", selection: $selectedBlock){
                            ForEach(blockObjects){
                                block in
                                Text("\(block.blockNumber)").tag(block.blockNumber)
                            }
                        }
                    }
                    HStack{
                        Text("Species:")
                        Picker("Species", selection: $selectedSpecies){
                            ForEach(newTallyData.getSpeciesList(block: selectedBlock) ?? []){
                                species in
                                Text("\(species.name)").tag(species)
                            }
                        }
                    }
                }
                
                Divider()
                
                VStack {
                    VStack (alignment: .trailing){
                        ForEach(Array(newPartialData.people), id: \.key){
                            planter, bundles in
                            RowView(planter: planter,
                                    bundles: bundles,
                                    newPartialData: $newPartialData,
                                    selectedSpecies: $selectedSpecies
                            )
                        }
                    }
                    Button(action: addPerson){
                        Text("Add Person")
                    }.padding()
                    
                }.padding()
                HStack{
                    Button(action: onOkay ) {
                        Text("Save   ").padding().background(.gray).foregroundColor(.black)
                    }.cornerRadius(45)
                    Button(action: onDiscard ) {
                        Text("Discard").padding().background(.gray).foregroundColor(.black)
                    }.cornerRadius(45)
                }
                
            }.onAppear(){
                newPartialData.people[selectedPlanter] = 0
                addPerson()
                //newPartialData.people[personStore.getCrew().first(where: {$0 != selectedPlanter})!] = 0
            }.alert(isPresented: $isShowingError) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("All bundles must be claimed amoungst two or more planters.")
                )
            }
            /*.popup(isPresented: $isShowingError) {
                ZStack{
                    Color.gray.frame(width: UIScreen.main.bounds.size.width*0.6, height: UIScreen.main.bounds.size.height*0.6).cornerRadius(45)
                    VStack(alignment: .center) {
                        Text("Invalid Input").font(.title)
                        Text("All bundles must be claimed amoungst two or more planters.").font(.caption)
                    }.padding().frame(width: UIScreen.main.bounds.size.width*0.6, height: UIScreen.main.bounds.size.height*0.6).foregroundColor(.white)
                }
            }*/
        }
    }
}

struct RowView: View {
    @State var planter : Person
    @State var bundles : Int
    @Binding var newPartialData : Partial
    @Binding var selectedSpecies : Species
    
    @EnvironmentObject var personStore : PersonStore
    
    var body: some View {
        HStack{
            Picker("Planter", selection: $planter){
                ForEach(personStore.getCrew()){
                    member in
                    Text("\(member.fullName)").tag(member)
                }
            }.onChange(of: planter){ [planter] newValue in
                print(planter)
                print(newValue)
                newPartialData.people[planter] = nil
                newPartialData.people[newValue] = bundles
            }
            Text("Planted ")
            Picker("Bundles", selection: $bundles){
                ForEach(0..<selectedSpecies.numBundles+1){ num in
                    Text("\(num)").tag(num)
                }
            }.onChange(of: bundles){ newValue in
                newPartialData.people[planter] = newValue
            }
            Text("Bundles")
        }.padding()
    }
}
/*
struct CreatePartialView_Previews: PreviewProvider {
    
    static var previews: some View {
        CreatePartialView(newTallyData: .constant(DailyTally.Data()),
                          isPresentingCreatePartialView: .constant(true),
                          newPartialData: .constant(Partial.Data(species: Species.sampleData[0], people: [Person.sampleData[0] : 5, Person.sampleData[1] : 5])),
                          selectedSpecies: Species(data: Species.Data()),
                          selectedBlock: Block(data: Block.Data()),
                          selectedPlanter: Person(data: Person.Data()),
                          partials: .constant([Partial(data: Partial.Data())])
        )
    }
}
*/
