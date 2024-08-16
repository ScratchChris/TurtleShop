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
    
    var body: some View {
        NavigationStack {
            List(selection: $dataController.selectedMeal) {
                Section("Items") {
                    ForEach(meals) { meal in
                            Text(meal.mealName)
                                .badge(meal.mealIngredients.count)
                                .swipeActions(edge: .trailing) {
                                    Button("", systemImage: "trash", role: .destructive, action: {
                                        dataController.delete(meal)
                                    })
                                    NavigationLink(destination: MealIngredientsList(meal: meal)) {
                                        Button("", systemImage: "pencil", action: {
                                            
                                        })
                                        .tint(.green)
                                    }
                                }
                        
                    }
                }
            }
            .navigationTitle("Meals")
        }
        
    }
}

#Preview {
    MealListView()
        .environmentObject(DataController.preview)
}
