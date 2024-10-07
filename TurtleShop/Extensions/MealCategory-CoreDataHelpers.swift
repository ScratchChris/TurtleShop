//
//  MealCategory-CoreDataHelpers.swift
//  TurtleShop
//
//  Created by Chris Turner on 13/08/2024.
//

import Foundation

extension MealCategory {
    var mealCategoryID: UUID {
        id ?? UUID()
    }
    
    var mealCategoryName: String {
        get { name ?? "" }
        set { name = newValue }
    }

    var categorySelectedMeals: [Meal] {
        let result = meals?.allObjects as? [Meal] ?? []
        return result.filter { $0.selected == true }
    }

    static var example: MealCategory {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let mealCategory = MealCategory(context: viewContext)
        mealCategory.id = UUID()
        mealCategory.name = "Example Meal Category"
        mealCategory.numberOfMeals = 2
        return mealCategory
    }
}

extension MealCategory: Comparable {
    public static func <(lhs: MealCategory, rhs: MealCategory) -> Bool {
        let left = lhs.mealCategoryName.localizedLowercase
        let right = rhs.mealCategoryName.localizedLowercase
        
        if left == right {
            return lhs.mealCategoryID.uuidString < rhs.mealCategoryID.uuidString
        } else {
            return left < right
        }
    }
}
