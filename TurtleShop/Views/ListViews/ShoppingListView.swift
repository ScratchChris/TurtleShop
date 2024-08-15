//
//  ShoppingListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var items: FetchedResults<Item>
    
    var body: some View {
        NavigationStack {
                List {
                    Section("Items") {
                        ForEach(items, id: \.itemID) { item in
                            ItemRow(item: item)
                                .contentShape(Rectangle())
                                .listRowBackground(item.listBackgroundColor)
                                .onTapGesture {
                                    item.itemStatus = .needed
                                    dataController.save()
                                }
                                .onLongPressGesture {
                                    item.itemStatus = .unneeded
                                    dataController.save()
                                }
                        }
                    }
                }

            .navigationTitle("TurtleShop")
            .toolbar {
                Button {
                    dataController.deleteAll()
                    dataController.createSampleData()
                } label: {
                    Label("ADD SAMPLES", systemImage: "flame")
                }
            }
        }
        
    }
}

#Preview {
   ShoppingListView()
        .environmentObject(DataController.preview)
}
