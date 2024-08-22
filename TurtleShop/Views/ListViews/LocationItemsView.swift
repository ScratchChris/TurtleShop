//
//  LocationItemsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct LocationItemsView: View {
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var location: Location
    
    @State private var isShowingNewItemView = false

    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "location = %@", location)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Location Name") {
                    VStack(alignment: .leading) {
                        TextField("Item Name", text: $location.locationName, prompt: Text("Enter the location name here"))
                            .font(.title)
                    }
                }
                
                List {
                    Section("Items in location") {
                        ForEach (items) { item in
                            ItemRow(item: item)
                                .contentShape(Rectangle())
                                .listRowBackground(item.listBackgroundColor)
                        }
                    }
                }
            }
            .navigationTitle(location.locationName)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(location.objectWillChange) { _ in
                dataController.queueSave()
            }
            .toolbar {
                Button {
                    dataController.selectedMeal = nil
                    dataController.selectedLocation = location
                    dataController.newItem()
                    isShowingNewItemView.toggle()
                } label : {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationDestination(isPresented: $isShowingNewItemView) {
                if let selectedItem = dataController.selectedItem {
                    ItemView(item: selectedItem)
                }
            }
        }
    }
}

#Preview {
    LocationItemsView(location: .example)
}
