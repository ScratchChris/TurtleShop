//
//  ShoppingTrip-CoreDataHelpers.swift
//  TurtleShop
//
//  Created by Chris Turner on 19/01/2025.
//

import Foundation
import SwiftUI

extension ShoppingTrip {

    var shoppingTripID: UUID {
        id ?? UUID()
    }

    var shoppingTripDate: Date {
        get { date ?? Date() }
        set { date = newValue }
    }

    var itemsInShoppingTrip: [Item] {
        let result = purchasedOnShoppingTrip?.allObjects as? [Item] ?? []
        return result.sorted()
    }

    static var example: ShoppingTrip {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let shoppingTrip = ShoppingTrip(context: viewContext)

        shoppingTrip.id = UUID()
        shoppingTrip.date = .now
        
        return shoppingTrip
    }

}
