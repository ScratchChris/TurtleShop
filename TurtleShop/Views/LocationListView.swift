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
    
    @State private var isShowingLocationItemsView = false
    
    var body: some View {
        NavigationStack {
            List {
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
            .toolbar {
                Button {
                    dataController.newLocation()
                    isShowingLocationItemsView.toggle()
                } label : {
                    Label("Add Meal", systemImage: "plus")
                }
            }
            .navigationDestination(isPresented: $isShowingLocationItemsView) {
                if let selectedLocation = dataController.selectedLocation {
                    LocationItemsView(location: selectedLocation)
                }
            }
            
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(DataController.preview)
}
