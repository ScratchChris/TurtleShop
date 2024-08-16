//
//  MealIngredientsList.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct MealIngredientsList: View {
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var meal: Meal
    
    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY meals = %@", meal)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var body: some View {
        Form {
            Section("Meal Name") {
                VStack(alignment: .leading) {
                    TextField("Item Name", text: $meal.mealName, prompt: Text("Enter the meal name here"))
                        .font(.title)
                }
            }
            Section("Meal Categories") {
                Text("Meal Categories to go here")
                    .foregroundStyle(.secondary)
            }
            Section("Ingredients") {
                if meal.mealIngredients.isEmpty {
                    Text("No ingredients in the meal yet")
                        .foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach (items) { item in
                            ItemRow(item: item)
                                .contentShape(Rectangle())
                                .listRowBackground(item.listBackgroundColor)
                        }
                    }
                }
            }
        }
        .navigationTitle(meal.mealName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MealIngredientsList(meal: .example)
}
