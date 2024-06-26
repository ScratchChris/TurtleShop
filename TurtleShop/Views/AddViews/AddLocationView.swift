//
//  AddLocationView.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import SwiftData
import SwiftUI

struct AddLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var locationName = ""
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Location Name", text: $locationName)
            }
            Section("Save") {
                Button("Save") {
                    let newLocation = Location(name: locationName)
                    modelContext.insert(newLocation)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddLocationView()
}
