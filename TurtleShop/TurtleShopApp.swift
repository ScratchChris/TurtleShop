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
//    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Shopping List", systemImage: "pencil.and.list.clipboard") {
                    ShoppingListView()
                }
                Tab("Meals", systemImage: "fork.knife") {
                    MealListView()
                }
                Tab("Locations", systemImage: "cabinet") {
                    LocationListView()
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
                  
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
//            .onChange(of: scenePhase) { oldValue, newValue in
//                if newValue != .active {
//                    dataController.save()
//                }
//            }
        }
    }
}
