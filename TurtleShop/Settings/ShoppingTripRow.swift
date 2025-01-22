//
//  ShoppingTripRow.swift
//  TurtleShop
//
//  Created by Chris Turner on 22/01/2025.
//

import CoreData
import SwiftUI

struct ShoppingTripRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var shoppingTrip: ShoppingTrip

    var body: some View {
        NavigationLink(destination: ShoppingTripView(shoppingTrip: shoppingTrip)) {
            Text(shoppingTrip.shoppingTripDate.formatted())
        }
    }
}

#Preview {
    ShoppingTripRow(shoppingTrip: ShoppingTrip.example)
}
