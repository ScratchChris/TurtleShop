//
//  MealIngredientsList.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct MealIngredientsList: View {
    @EnvironmentObject var dataController: DataController
    
    var meal: Meal

    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY meals = %@", meal)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var body: some View {
        List {
            ForEach (items) { item in
                Text(item.itemName)
            }
        }
        .navigationTitle(meal.mealName)
    }
}

#Preview {
    MealIngredientsList(meal: .example)
}
