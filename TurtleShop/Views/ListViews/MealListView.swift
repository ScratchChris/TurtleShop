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
    
    @State private var ingredientsViewShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Items") {
                    ForEach(meals) { meal in
                        MealRow(meal: meal)
                            .badge(meal.mealIngredients.count)
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
                            }
                            .onLongPressGesture {
                                meal.selected = false
                            }
                    }
                }
            }
            .toolbar {
                Button {
                    dataController.newMeal()
                    ingredientsViewShowing.toggle()
                } label : {
                    Label("Add Meal", systemImage: "plus")
                }
            }
            .navigationTitle("Meals")
            .navigationDestination(isPresented: $ingredientsViewShowing) {
                if let selectedMeal = dataController.selectedMeal {
                    MealIngredientsList(meal: selectedMeal)
                }
            }
        }
        
    }
}

#Preview {
    MealListView()
        .environmentObject(DataController.preview)
}
