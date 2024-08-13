//
//  ItemRow.swift
//  TurtleShop
//
//  Created by Chris Turner on 14/08/2024.
//

import SwiftUI

struct ItemRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var item: Item
    
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
                if item.meals != nil {
                    let numberOfSelectedMeals = String(2)
                    // add in item.meals.count bit here
                    Image(systemName: "\(numberOfSelectedMeals).square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .blue)
                }
            }
            if item.itemStatus == .unselected {
                Text(item.itemName)
            } else if item.itemStatus == .needed {
                Text(item.itemName)
                Spacer()
                Image(systemName: "checkmark")
            } else if item.itemStatus == .unneeded {
                Text(item.itemName)
                    .strikethrough()
                Spacer()
                Image(systemName: "xmark")
                
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
                //Edit
            })
            .tint(.green)
        }
    }
}

#Preview {
    ItemRow(item: .example)
}
