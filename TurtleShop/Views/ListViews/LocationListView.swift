//
//  LocationListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 08/08/2024.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var locations: FetchedResults<Location>
    
    var body: some View {
        NavigationStack {
            List {
                Section("Items") {
                    ForEach(locations) { location in
                        
                        Text(location.locationName)
                            .badge(location.locationItems.count)
                            .swipeActions(edge: .trailing) {
                                Button("", systemImage: "trash", role: .destructive, action: {
                                    dataController.delete(location)
                                })
                                NavigationLink(destination: LocationItemsView(location: location)) {
                                    Button("", systemImage: "pencil", action: {
                                        
                                    })
                                    .tint(.green)
                                }
                                
                            }
                    }
                }
                .navigationTitle("Locations")
            }
            
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(DataController.preview)
}
