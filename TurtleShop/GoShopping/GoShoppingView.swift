//
//  GoShoppingView.swift
//  TurtleShop
//
//  Created by Chris Turner on 19/01/2025.
//

import CoreData
import SwiftUI

struct GoShoppingView: View {
    @EnvironmentObject var dataController: DataController

    @ObservedObject var shoppingTrip: ShoppingTrip

    var items: [Item] {
        var allItems: [Item]

        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY shoppingTrips == %@", shoppingTrip)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []

        return allItems.sorted()
    }

    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.itemName)
            }
        }
    }
}

#Preview {
    GoShoppingView(shoppingTrip: ShoppingTrip.example)
}
