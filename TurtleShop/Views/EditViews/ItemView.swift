//
//  ItemView.swift
//  TurtleShop
//
//  Created by Chris Turner on 16/08/2024.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var item: Item
    @Environment(\.presentationMode) var presentationMode
    @State private var new = false
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var locations: FetchedResults<Location>
    
    
    var body: some View {
        Form {
            Section("Item Name") {
                VStack(alignment: .leading) {
                    TextField("Item Name", text: $item.itemName, prompt: Text("Enter the item name here"))
                        .font(.title)
                }
            }
            Section("Item Details") {
                if item.itemNewOrStaple == .neither {
                    Text("Item is currently only in meals and not in the main shopping list.  To add this as a seperate item to your main shopping list, check the staple box below")
                        .foregroundStyle(.secondary)
                        .animation(.easeInOut)
                }
                    
                if item.itemNewOrStaple == .new {
                        Text("New Item!")
                            .contentShape(Rectangle())
                            .listRowBackground(Color.green.opacity(0.2))
                    }
                    Toggle(isOn: .init(
                        get: { item.itemNewOrStaple == .staple },
                        set: { newValue in item.itemNewOrStaple = newValue ? .staple : .neither }
                    
                    
                    ) ) {
                        Text("Staple Item")
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color.yellow.opacity(0.2))
                        .tint(.yellow)
                }
              
                
                //Staple check box, or status of new, or neither because it's in a meal.  If it's only in a meal, show it as only in a meal (and which meal) and allow for selection of staple.
            
            Section("Item Location") {
                Picker("Location", selection: $item.location) {
                    ForEach(locations) { location in
                        Text(location.locationName).tag(location)
                    }
                }
                .pickerStyle(.wheel)
                
            }
            
            Section("Item Meals") {
                if item.itemMeals.isEmpty {
                    Text("Item is currently not in any meals")
                        .foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach(item.itemMeals) { meal in
                            Text(meal.mealName)
                        }
                    }
                }
            }
            
           
            Section {
                Button("Save Item") {
                    dataController.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onReceive(item.objectWillChange) { _ in
            dataController.queueSave()
        }
    }
}

#Preview {
    ItemView(item: .example)
}
