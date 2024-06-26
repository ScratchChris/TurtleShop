//
//  Item.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import Foundation
import SwiftData

enum NewOrStaple: Codable {
    case new, staple, blank
}

enum Status: Codable {
    case unselected, needed, unneeded
}

@Model
class Item {
    var id = UUID()
    var name: String
    var newOrStaple: NewOrStaple
    var status: Status
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
