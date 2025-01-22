//
//  ShoppingTrips.swift
//  TurtleShop
//
//  Created by Chris Turner on 21/01/2025.
//

import CoreData
import SwiftUI

struct ShoppingTrips: View {

    @EnvironmentObject var dataController: DataController

    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var allShoppingTrips: FetchedResults<ShoppingTrip>

    var body: some View {
        NavigationStack {
            List {
                ForEach(allShoppingTrips) { shoppingTrip in
                    ShoppingTripRow(shoppingTrip: shoppingTrip)
                        .swipeActions(edge: .trailing) {
                            Button("", systemImage: "trash", role: .destructive, action: {
                                dataController.delete(shoppingTrip)
                            })
                        }
                }
            }
            .navigationTitle("Shopping Trips")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    ShoppingTrips()
}
