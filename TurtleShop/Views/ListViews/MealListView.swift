//
//  MealListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftUI

struct MealListView: View {
    var meal : Meal
    
    var body: some View {
        Text(meal.name)
    }
}

#Preview {
    MealListView(meal:Meal(name: "Test"))
}
