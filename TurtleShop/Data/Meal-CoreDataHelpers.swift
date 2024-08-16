//
//  Meal-CoreDataHelpers.swift
//  TurtleShop
//
//  Created by Chris Turner on 13/08/2024.
//

import Foundation

extension Meal {
    var mealID: UUID {
        id ?? UUID()
    }
    
    var mealName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    var mealIngredients: [Item] {
        let result = ingredients?.allObjects as? [Item] ?? []
        return result.sorted()
    }
    
    var mealCategories: [MealCategory] {
        let result = categories?.allObjects as? [MealCategory] ?? []
        return result.sorted()
    }
    
    static var example: Meal {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let meal = Meal(context: viewContext)
        meal.name = "Example Meal"
        meal.id = UUID()
        return meal
    }
    
}

extension Meal: Comparable {
    public static func <(lhs: Meal, rhs: Meal) -> Bool {
        let left = lhs.mealName.localizedLowercase
        let right = rhs.mealName.localizedLowercase
        
        if left == right {
            return lhs.mealID.uuidString < rhs.mealID.uuidString
        } else {
            return left < right
        }
    }
}
