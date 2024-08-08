//
//  TurtleShopApp.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import SwiftUI

@main
struct TurtleShopApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Shopping List", systemImage: "pencil.and.list.clipboard") {
                    ShoppingListView()
                }
                .badge(2)
                Tab("Meals", systemImage: "fork.knife") {
                    MealListView()
                }
                Tab("Locations", systemImage: "cabinet") {
                    LocationListView()
                }
                Tab("Settings", systemImage: "gear") {
                    Text("Settings")
                }
                  
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
