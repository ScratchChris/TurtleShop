//
//  Item.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import Foundation
import SwiftData
import SwiftUI

enum NewOrStaple: Codable {
    case new, staple, blank
}

enum Status: Codable {
    case unselected, needed, unneeded
}

@Model
class Item {
    @Attribute(.unique) var id = UUID()
    var name: String
    var newOrStaple: NewOrStaple
    var status: Status
    var listBackgroundColor: Color {
        switch status {
        case .unselected:
            return Color.white
        case .needed:
            return Color.green.opacity(0.2)
        case .unneeded:
            return Color.red.opacity(0.2)
        }
    }
    
    
    @Relationship(deleteRule: .noAction) let location: Location
    @Relationship(deleteRule: .noAction) let meals: [Meal]?
    
    init (id: UUID, name: String, newOrStaple: NewOrStaple, status: Status, location: Location, meals: [Meal]) {
        self.id = id
        self.name = name
        self.newOrStaple = newOrStaple
        self.status = status
        self.location = location
        self.meals = meals
    }
}
