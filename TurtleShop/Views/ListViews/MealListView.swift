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
            List {
                Section("Items") {
                    ForEach(meals) { meal in
                        Text(meal.name ?? "No name")
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
