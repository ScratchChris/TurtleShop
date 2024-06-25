//
//  ShoppingListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct ShoppingListView: View {
    
    @State private var isShowingAddItemView = false
    @State private var isShowingNoLocationsAlert = false
    @State private var isShowingAddLocationView = false
    
    @Environment(\.modelContext) var modelContext
    @Query var items : [Item]
    @Query var locations: [Location]
    
    var body: some View {
        NavigationStack() {
            if items.count == 0 {
                ContentUnavailableView {
                    Label("No items", systemImage: "text.badge.plus")
                } description: {
                    Text("You don't have any items yet.")
                } actions: {
                    Button("Add First Item") {
                        if locations.count == 0 {
                            isShowingNoLocationsAlert.toggle()
                        } else {
                            isShowingAddItemView.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Shopping List")
                .toolbar {
                    Button("Add Item", systemImage: "plus") {
                        if locations.count == 0 {
                            isShowingNoLocationsAlert.toggle()
                        } else {
                            isShowingAddItemView.toggle()
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddItemView) {
                    AddItemView()
                }
                .alert("You have no locations and need one before adding an item",isPresented: $isShowingNoLocationsAlert) {
                    Button("Add first location") {
                        isShowingAddLocationView.toggle()
                    }
                }
                .sheet(isPresented: $isShowingAddLocationView) {
                    AddLocationView()
                }
            } else {
                List {
                    ForEach (items) { item in
                        ItemListView(item: item)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Shopping List")
                .toolbar {
                    Button("Add Item", systemImage: "plus") {
                        isShowingAddItemView.toggle()
                    }
                }
                .sheet(isPresented: $isShowingAddItemView) {
                    AddItemView()
                }
            }
        }
    }
    
    func addItem() {
        
    }
    
}


#Preview {
    ShoppingListView()
}
