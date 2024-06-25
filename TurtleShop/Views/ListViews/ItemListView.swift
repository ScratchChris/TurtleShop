//
//  ItemListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftUI

struct ItemListView: View {
    var item: Item
    
    var body: some View {
        Text(item.name)
    }
}

#Preview {
    ItemListView(item: Item(name: "Test", location: Location(name: "Fridge"), meals:[Meal(name: "Test")]))
}
