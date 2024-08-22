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
    
    @State private var isShowingNewItemView = false
    
    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY meals = %@", meal)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var itemsNotInMeal: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY meals != %@", meal)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }

    
    var body: some View {
        NavigationStack {
            
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
                Section("Ingredients (Long press to remove from meal)") {
                    if meal.mealIngredients.isEmpty {
                        Text("No ingredients in the meal yet")
                            .foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach (items) { item in
                                IngredientsRow(item: item)
                                    .contentShape(Rectangle())
                                    .onLongPressGesture {
                                        item.removeFromMeals(meal)
                                    }
                            }
                        }
                    }
                }
                
                Section("Tap other items to add to meal") {
                    List {
                        ForEach(itemsNotInMeal) { item in
                            IngredientsRow(item: item)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    item.addToMeals(meal)
                                }
                        }
                    }
                }
            }
            .navigationTitle(meal.mealName)
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(meal.objectWillChange) { _ in
                dataController.queueSave()
            }
            .toolbar {
                Button {
                    dataController.selectedMeal = meal
                    dataController.newItem()
                    isShowingNewItemView.toggle()
                } label : {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .navigationDestination(isPresented: $isShowingNewItemView) {
                if let selectedItem = dataController.selectedItem {
                    ItemView(item: selectedItem)
                }
            }
        }
    }
}

#Preview {
    MealIngredientsList(meal: .example)
}
