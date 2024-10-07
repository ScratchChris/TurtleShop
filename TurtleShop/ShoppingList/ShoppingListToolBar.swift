//
//  ShoppingListToolBar.swift
//  TurtleShop
//
//  Created by Chris Turner on 13/01/2025.
//

import SwiftUI

struct ShoppingListToolBar: View {
    @EnvironmentObject var dataController: DataController
    @Binding var isShowingNoLocationsAlert : Bool
    @Binding var isShowingItemView : Bool

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var locations: FetchedResults<Location>

    var body: some View {
            Button {
                if locations.isEmpty {
                    isShowingNoLocationsAlert.toggle()
                } else {
                    dataController.newItem()
                    isShowingItemView.toggle()
                }
            } label : {
                Label("Add Item", systemImage: "plus")
            }
            .sheet(isPresented: $isShowingItemView) {
                ItemView(item: dataController.selectedItem!)

            }
            .interactiveDismissDisabled()

#if DEBUG
            Button {
                dataController.deleteAll()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
#endif
    }
}

#Preview {
    ShoppingListToolBar(isShowingNoLocationsAlert: .constant(true), isShowingItemView: .constant(true))
}
