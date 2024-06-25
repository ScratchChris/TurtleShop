//
//  ContentView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ShoppingListView()
                .tabItem {
                    Label("List", systemImage: "list.bullet.indent")
                }
            
            MealsView()
                .tabItem {
                    Label("Meals", systemImage: "fork.knife")
                }
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
