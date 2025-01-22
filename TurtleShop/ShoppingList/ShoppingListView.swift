//
//  ShoppingListView.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var dataController: DataController
    
    @SectionedFetchRequest<String?, Item>(
        sectionIdentifier: \.location!.name,
        sortDescriptors: [
            SortDescriptor(\.location!.name, order: .forward),
            SortDescriptor(\.status, order: .forward),
            SortDescriptor(\.name, order: .forward)
        ],
        predicate: NSPredicate(format: "onShoppingList == true"),
                animation: (.easeInOut)
    )
    private var sectionedItems: SectionedFetchResults<String?, Item>

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var allItems: FetchedResults<Item>


    @State private var isShowingNoLocationsAlert = false
    @State private var isShowingItemView = false
    @State private var goShopping = false

    var body: some View {
        NavigationStack {
            List(sectionedItems) { section in
                Section(header: Text(section.id ?? "")) {
                    ForEach(section) { item in
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
            .navigationBarTitleDisplayMode(.inline)
            //            .searchable(text: $dataController.filterText)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Go Shopping!") {
                        dataController.newShoppingTrip()
                        for item in allItems {
                            item.purchased = false
                            if item.itemStatus == .needed {
                                dataController.selectedShoppingTrip!.addToPurchasedOnShoppingTrip(item)
                            }
                        }
                        goShopping.toggle()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    ShoppingListToolBar(isShowingNoLocationsAlert: $isShowingNoLocationsAlert, isShowingItemView: $isShowingItemView)
                }
            }
            .alert("No Locations", isPresented: $isShowingNoLocationsAlert) {
                Button("Ok", role: .cancel) { }
            }
            .navigationDestination(isPresented: $goShopping) {
                if let selectedShoppingTrip = dataController.selectedShoppingTrip {
                    GoShoppingView(shoppingTrip: selectedShoppingTrip)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(DataController.preview)
}
