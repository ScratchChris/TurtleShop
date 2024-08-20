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
        ]
//        animation: (.easeInOut)
    )
    private var sectionedItems: SectionedFetchResults<String?, Item>
    
    
    
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
//            .searchable(text: $dataController.filterText)
            
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
