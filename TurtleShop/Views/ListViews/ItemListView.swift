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
        ZStack {
            if item.status == .unselected {
                
            } else if item.status == .needed {
                Color.green
                    .opacity(0.2)
            } else if item.status == .unneeded {
                Color.red
                    .opacity(0.2)
            }
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
            .padding([.leading, .trailing])
        }
    }
}
        
        #Preview {
            ItemListView(item: Item(id: UUID(), name: "Test", newOrStaple: .new, status: .needed, location: Location(name: "Fridge"), meals: []))
        }
