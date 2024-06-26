//
//  AddItemView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var locations : [Location]
    
    @State private var itemName = ""
    @State private var selectedLocation = 0
    @State private var staple = false
    
    
    var body: some View {
        Form {
            Section("Item Name") {
                TextField("Enter the name of the item", text: $itemName)
            }
            Section("Staple Item") {
                Toggle("Staple Item", isOn: $staple)
            }
            Section("Location") {
                Picker("Select a location", selection: $selectedLocation) {
                                ForEach(locations, id: \.self) {
                                    Text($0.name)
                                }
                            }
                .frame(height: 100, alignment: .center)
                .pickerStyle(.wheel)
            }
            Section("Save") {
                Button("Save") {
                    let newOrStapleSelection: NewOrStaple = staple ? .staple : .new
                    
                    print(selectedLocation)
                    let item = Item(id: UUID(), name: itemName, newOrStaple: newOrStapleSelection, status: .unselected, location: locations[selectedLocation], meals: [])
                    
                    modelContext.insert(item)
                    dismiss()
                }
            }
        }
        
    }
}

#Preview {
    AddItemView()
}
