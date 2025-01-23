//
//  ManualItemOrderView.swift
//  TurtleShop
//
//  Created by Chris Turner on 23/01/2025.
//

import CoreData
import SwiftUI

struct ManualItemOrderView: View {
    @EnvironmentObject var dataController: DataController

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.shoppingListOrder, ascending: true)]) var allItems: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            List {
                ForEach(allItems) { item in
                    HStack {
                        Text(item.itemName)
                        Text("\(item.shoppingListOrder)")
                    }
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Shopping List Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func moveItem(at sets:IndexSet,destination: Int) {
        let itemToMove = sets.first!
        if itemToMove < destination {
            var startIndex = itemToMove + 1

            let endIndex = destination

            var startOrder = allItems[itemToMove].shoppingListOrder

            while startIndex < endIndex {
                print(allItems[startIndex].itemName)
                print(startOrder)
                allItems[startIndex].shoppingListOrder = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
                print("Start Index - \(startIndex)")
                print("End Index = \(endIndex)")
            }
            allItems[itemToMove].shoppingListOrder = startOrder

        } else if destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = allItems[destination].shoppingListOrder + 1
            let newOrder = allItems[destination].shoppingListOrder
            while startIndex <= endIndex {
                allItems[startIndex].shoppingListOrder = startOrder
                startOrder = startOrder + 1
                startIndex = startIndex + 1
            }
            allItems[itemToMove].shoppingListOrder = newOrder
        }
        dataController.save()
    }

    private func deleteItem(at offset:IndexSet) {
        withAnimation{
            offset.map{ allItems[$0] }.forEach(dataController.delete)
            dataController.save()
        }
    }
}

#Preview {
    ManualItemOrderView()
}
