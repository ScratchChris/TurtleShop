//
//  MealListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 08/08/2024.
//

import SwiftUI

struct MealListView: View {
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var meals: FetchedResults<Meal>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var mealCategories: FetchedResults<MealCategory>

    @State private var ingredientsViewShowing = false
    @State private var mealCategoriesViewShowing = false

    var body: some View {
        NavigationStack {
            List {
                Section("Categories") {
                    ForEach(mealCategories) { mealCategory in
                        HStack {
                            Text(mealCategory.mealCategoryName)
                            Spacer()
                            Text("\(mealCategory.categorySelectedMeals.count)/\(mealCategory.numberOfMeals)")
                        }
                    }
                }
                Section("Meals") {
                    ForEach(meals) { meal in
                        MealRow(meal: meal)
                            .badge("\(meal.mealIngredients.count) Items")
                            .swipeActions(edge: .trailing) {
                                Button("", systemImage: "trash", role: .destructive, action: {
                                    dataController.delete(meal)
                                })
                                NavigationLink(destination: MealIngredientsList(meal: meal)) {
                                    
                                    Button("", systemImage: "pencil", action: {
                                        dataController.selectedMeal = meal
                                    })
                                    .tint(.green)
                                }
                                
                            }
                            .onTapGesture {
                                meal.selected = true
                                for item in meal.mealIngredients {
                                    item.onShoppingList = true
                                }
                            }
                            .onLongPressGesture {
                                meal.selected = false
                                for item in meal.mealIngredients {
                                    item.onShoppingList = false
                                }
                            }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Meal") {
                        dataController.newMeal()
                        ingredientsViewShowing.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Edit Categories") {
                        mealCategoriesViewShowing.toggle()
                    }
                }
            }
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $ingredientsViewShowing) {
                if let selectedMeal = dataController.selectedMeal {
                    MealIngredientsList(meal: selectedMeal)
                }
            }
            .navigationDestination(isPresented: $mealCategoriesViewShowing) {
                MealCategoryList()
            }
        }
        
    }
}

#Preview {
    MealListView()
        .environmentObject(DataController.preview)
}
