//
//  LocationsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct LocationsView: View {
    @State private var isShowingAddLocationView = false
    
    @Environment(\.modelContext) var modelContext
    @Query var locations: [Location]
    
    var body: some View {
        NavigationStack {
//            if locations.isEmpty {
//                ContentUnavailableView {
//                    Label("No Locations", systemImage: "door.french.closed")
//                } description: {
//                    Text("You don't have any locations yet.")
//                } actions: {
//                    Button("Add First Location") {
//                        isShowingAddLocationView.toggle()
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarTitle("Shopping List")
//                .toolbar {
//                    Button("Add Item", systemImage: "plus") {
//                        isShowingAddLocationView.toggle()
//                    }
//                }
//                .sheet(isPresented: $isShowingAddLocationView) {
//                    AddLocationView()
//                }
//                .onAppear() {
//                    print(locations.isEmpty)
//                }
//            } else {
                List {
                    ForEach (locations) { location in
                        LocationListView(location: location)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Locations")
                .toolbar {
                    Button("Add Location", systemImage: "plus") {
                        isShowingAddLocationView.toggle()
                    }
                }
                .sheet(isPresented: $isShowingAddLocationView) {
                    AddLocationView()
                }
//            }
                
        }
    }
}

#Preview {
    LocationsView()
}
