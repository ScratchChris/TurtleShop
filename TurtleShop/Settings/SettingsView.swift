//
//  SettingsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 12/01/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Items") {
                    NavigationLink(destination: ManualItemOrderView()) {
                        Text("Manually order the items")
                    }
                }
                Section("Awards") {
                    NavigationLink(destination: AwardsView()) {
                        Text("Awards")
                    }
                }
                Section("Shopping Trips") {
                    NavigationLink(destination: ShoppingTrips()) {
                        Text("Shopping Trips")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
