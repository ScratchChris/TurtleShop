//
//  IngredientsRow.swift
//  TurtleShop
//
//  Created by Chris Turner on 14/08/2024.
//

import SwiftUI

struct IngredientsRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var item: Item
    @State private var isShowingItemView = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if item.itemNewOrStaple == .staple {
                    Image(systemName: "s.square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .yellow)
                }
                else if item.itemNewOrStaple == .new {
                    Image(systemName: "n.square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .green)
                }
                if item.itemMeals.count != 0 {
                    let numberOfSelectedMeals = item.itemMeals.count
                    Image(systemName: "\(numberOfSelectedMeals).square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .blue)
                }
            }
            Text(item.itemName)

        }
        .navigationDestination(isPresented: $isShowingItemView) {
            if let selectedItem = dataController.selectedItem {
                ItemView(item: selectedItem)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                if item.itemNewOrStaple == .new {
                    item.itemNewOrStaple = .staple
                } else if item.itemNewOrStaple == .staple {
                    item.itemNewOrStaple = .new
                }
            } label: {
                if item.itemNewOrStaple == .new {
                    Label("Staple", systemImage: "pin")
                } else if item.itemNewOrStaple == .staple {
                    Label("Unstaple", systemImage: "pin.slash")
                }
                
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button("", systemImage: "trash", role: .destructive, action: {
                dataController.delete(item)
            })
            Button("", systemImage: "pencil", action: {
                dataController.selectedItem = item
                isShowingItemView.toggle()
            })
            .tint(.green)
        }
    }
}

#Preview {
    IngredientsRow(item: .example)
}
