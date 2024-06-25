//
//  ShoppingListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct ShoppingListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var items : [Item]
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach (items) { item in
                    ItemListView(item: item)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Shopping List")
            .toolbar {
                Button("Add Item", systemImage: "plus", action: addItem)
            }
        }
    }
    
    func addItem() {
        
    }
    
}


#Preview {
    ShoppingListView()
}
