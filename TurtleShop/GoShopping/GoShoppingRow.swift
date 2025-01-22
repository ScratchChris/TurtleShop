//
//  GoShoppingRow.swift
//  TurtleShop
//
//  Created by Chris Turner on 14/08/2024.
//

import SwiftUI

struct GoShoppingRow: View {
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
                if item.itemSelectedMeals.count != 0 {
                    let numberOfSelectedMeals = item.itemMeals.count
                    Image(systemName: "\(numberOfSelectedMeals).square.fill")
                        .symbolVariant(.square)
                        .foregroundStyle(.white, .blue)
                }
            }
            if item.purchased == false {
                Text(item.itemName)
            } else if item.purchased == true {
                Text(item.itemName)
                    .strikethrough()
                Spacer()
                Image(systemName: "checkmark")
            }
        }
    }
}

#Preview {
    GoShoppingRow(item: .example)
}
