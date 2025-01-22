//
//  GoShoppingView.swift
//  TurtleShop
//
//  Created by Chris Turner on 19/01/2025.
//

import CoreData
import SwiftUI

struct GoShoppingView: View {
    @EnvironmentObject var dataController: DataController

    @Environment(\.presentationMode) var presentationMode

    @State private var isShowingCompleteWarning = false
    @State private var isShowingCancelWarning = false

    @ObservedObject var shoppingTrip: ShoppingTrip

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var allItems: FetchedResults<Item>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var allMeals: FetchedResults<Meal>

    var itemsToPurchase: [Item] {
        var allItems: [Item]

        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "(ANY shoppingTrips == %@) AND NOT purchased == true", shoppingTrip)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []

        return allItems.sorted()
    }

    var purchasedItems: [Item] {
        var allItems: [Item]

        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "(ANY shoppingTrips == %@) AND purchased == true", shoppingTrip)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []

        return allItems.sorted()
    }

    var body: some View {
        List {
            Section("Items to purchase") {
                ForEach(itemsToPurchase) { item in
                    GoShoppingRow(item: item)
                        .listRowBackground(item.goShoppingBackgroundColor)
                        .onTapGesture {
                            item.purchased = true
                            dataController.save()
                        }
                }
            }
            Section("Purchased Items") {
                ForEach(purchasedItems) { item in
                    GoShoppingRow(item: item)
                        .listRowBackground(item.goShoppingBackgroundColor)
                        .onTapGesture {
                            item.purchased = false
                            dataController.save()
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Complete") {
                    for item in itemsToPurchase {
                        item.removeFromShoppingTrips(shoppingTrip)
                    }
                    for item in purchasedItems {
                        item.purchased = false
                    }
                    dataController.selectedShoppingTrip = nil
                    completeShop()
                    dataController.save()
                    self.presentationMode.wrappedValue.dismiss()

                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Stop", role: .destructive) {
                  // Code
                }
                .foregroundColor(.red)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //Add new item
                } label : {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }

    }

    func completeShop() {

        for item in allItems {
            item.itemStatus = .unselected
        }

        for meal in allMeals {
            meal.selected = false
            for item in meal.mealIngredients {
                if item.itemNewOrStaple == .staple {

                } else {
                    item.onShoppingList = false
                }
            }
        }

    }
}

#Preview {
    GoShoppingView(shoppingTrip: ShoppingTrip.example)
}
