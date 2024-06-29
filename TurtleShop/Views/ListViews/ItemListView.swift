//
//  ItemListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftUI

struct ItemListView: View {
    var item: Item
    
    var body: some View {
        HStack {
            VStack {
                if item.newOrStaple == .staple {
                    Image(systemName: "s.square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .yellow)
                } else if item.newOrStaple == .new {
                    Image(systemName: "n.square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .green)
                }
            }
            if item.status == .unselected {
                Text(item.name)
            } else if item.status == .needed {
                Text(item.name)
                Spacer()
                Image(systemName: "checkmark")
            } else if item.status == .unneeded {
                Text(item.name)
                    .strikethrough()
                Spacer()
                Image(systemName: "xmark")
                
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                if item.newOrStaple == .new {
                    item.newOrStaple = .staple
                } else if item.newOrStaple == .staple {
                    item.newOrStaple = .new
                }
            } label: {
                if item.newOrStaple == .new {
                    Label("Staple", systemImage: "pin")
                } else if item.newOrStaple == .staple {
                    Label("Unstaple", systemImage: "pin.slash")
                }
                
            }
            .tint(.yellow)
        }
        .swipeActions(edge: .trailing) {
            Button("", systemImage: "trash", role: .destructive, action: {
                //Delete Code
            })
            Button("", systemImage: "pencil", action: {
                //Edit
            })
            .tint(.green)
        }
    }
}

#Preview {
    ItemListView(item: Item(id: UUID(), name: "Test", newOrStaple: .new, status: .needed, location: Location(name: "Fridge"), meals: []))
}
