//
//  MealsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct MealsView: View {
    @State private var isShowingAddMealView = false
    
    @Environment(\.modelContext) var modelContext
    @Query var meals: [Meal]
    
    
    var body: some View {
        NavigationStack {
            if meals.count == 0 {
                ContentUnavailableView {
                    Label("No Meals", systemImage: "fork.knife")
                } description: {
                    Text("You don't have any meals yet.")
                } actions: {
                    Button("Add First Meal") {
                        isShowingAddMealView.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Shopping List")
                .toolbar {
                    Button("Add Item", systemImage: "plus") {
                        isShowingAddMealView.toggle()
                    }
                }
                .sheet(isPresented: $isShowingAddMealView) {
                    AddItemView()
                }
            } else {
                
                
                List {
                    ForEach (meals) { meal in
                        MealListView(meal: meal)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Meals")
                .toolbar {
                    Button("Add Meal", systemImage: "plus") {
                        isShowingAddMealView.toggle()
                    }
                }
                .sheet(isPresented: $isShowingAddMealView) {
                    AddMealView()
                }
            }
        }
        
    }
}

#Preview {
    MealsView()
}
