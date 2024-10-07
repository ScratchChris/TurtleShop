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
                NavigationLink(destination: AwardsView()) {
                    Text("Awards")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
