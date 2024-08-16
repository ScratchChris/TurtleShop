//
//  LocationItemsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct LocationItemsView: View {
    @EnvironmentObject var dataController: DataController
    
    var location: Location

    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "location = %@", location)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var body: some View {
        List {
            ForEach (items) { item in
                ItemRow(item: item)
                    .contentShape(Rectangle())
                    .listRowBackground(item.listBackgroundColor)
            }
        }
        .navigationTitle(location.locationName)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(location.objectWillChange) { _ in
            dataController.queueSave()
        }
    }
}

#Preview {
    LocationItemsView(location: .example)
}
