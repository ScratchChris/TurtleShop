//
//  LocationListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftUI

struct LocationListView: View {
    var location : Location
    
    var body: some View {
        Text(location.name)
    }
}

#Preview {
    MealListView(meal:Meal(name: "Test"))
}
