//
//  ContentView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var items : [Item]
    
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach (items) { item in
                    ItemListView(item: item)
                }
            }
            .navigationTitle("TurtleShop")
            .toolbar {
                Button("Add Item", systemImage: "plus", action: addItem)
            }
        }
    }
    
    func addItem() {
        let item = Item(name: "Test")
        modelContext.insert(item)
    }

}

#Preview {
    ContentView()
}
