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
        }
    }
}

#Preview {
    LocationsView()
}
