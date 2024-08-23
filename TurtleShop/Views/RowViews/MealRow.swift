//
//  MealRow.swift
//  TurtleShop
//
//  Created by Chris Turner on 23/08/2024.
//

import SwiftUI

struct MealRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var meal: Meal
    
    var body: some View {
//        if meal.selected == false {
        HStack {
            Image(systemName: "checkmark")
                .opacity(meal.selected == false ? 0 : 1)
            Text(meal.mealName)
        }
//        } else {
//            Image(systemName: "checkmark")
//                .opacity(meal.selected == false ? 1 : 0)
//            Text(meal.mealName)
//            Spacer()
//            
//        }
    }
}

#Preview {
    MealRow(meal: .example)
}
