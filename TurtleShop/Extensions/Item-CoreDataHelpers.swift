//
//  Item-CoreDataHelpers.swift
//  TurtleShop
//
//  Created by Chris Turner on 13/08/2024.
//

import Foundation
import SwiftUI

extension Item {
    
    var itemID: UUID {
        id ?? UUID()
    }
    
    var itemName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    var itemLocation: Location {
        get { location ?? Location() }
        set { location = newValue }
    }

    var itemShoppingListOrder: Int64 {
        get { shoppingListOrder ?? 0 }
        set { shoppingListOrder = newValue }
    }

    var itemMeals: [Meal] {
        let result = meals?.allObjects as? [Meal] ?? []
        return result.sorted()
    }
    
    var itemSelectedMeals: [Meal] {
        let result = meals?.allObjects as? [Meal] ?? []
        return result.filter { $0.selected == true }
    }
    
    var mealsCount: Int {
        meals?.count ?? 0
    }
    
    var listBackgroundColor: Color {
        switch itemStatus {
        case .unselected:
            return Color(UIColor.secondarySystemGroupedBackground)
        case .needed:
            return Color.green.opacity(0.2)
        case .unneeded:
            return Color.red.opacity(0.2)
        }
    }

    var goShoppingBackgroundColor: Color {
        switch purchased {
        case true:
            return Color.green.opacity(0.2)
        case false:
            return Color(UIColor.secondarySystemGroupedBackground)
        }
    }

    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        item.id = UUID()
        item.name = "Example Item"
        item.newOrStaple = 1
        item.onShoppingList = true
        item.status = 1
        let newLocation = Location(context: viewContext)
        newLocation.id = UUID()
        newLocation.name = "Example Location"
        item.location = newLocation
        return item
    }
}

extension Item: Comparable {
    public static func <(lhs: Item, rhs: Item) -> Bool {
        let left = lhs.itemName.localizedLowercase
        let right = rhs.itemName.localizedLowercase
        
        if left == right {
            return lhs.itemID.uuidString < rhs.itemID.uuidString
        } else {
            return left < right
        }
    }
}
