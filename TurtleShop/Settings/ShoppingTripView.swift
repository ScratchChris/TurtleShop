//
//  ShoppingTripView.swift
//  TurtleShop
//
//  Created by Chris Turner on 22/01/2025.
//

import CoreData
import SwiftUI

struct ShoppingTripView: View {
    @EnvironmentObject var dataController: DataController

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var shoppingTrip: ShoppingTrip

    var body: some View {
        NavigationStack {
            List {
                ForEach(shoppingTrip.itemsInShoppingTrip, id: \.self) { item in
                    Text(item.itemName)
                }
            }
            .navigationTitle(shoppingTrip.shoppingTripDate.formatted())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ShoppingTripView(shoppingTrip: ShoppingTrip.example)
}
