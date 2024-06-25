//
//  Item.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import Foundation
import SwiftData

@Model
class Item {
    var name: String
    @Relationship(deleteRule: .noAction) let location: Location
    @Relationship(deleteRule: .noAction) let meals: [Meal]
    
    init (name: String, location: Location, meals: [Meal]) {
        self.name = name
        self.location = location
        self.meals = meals
    }
}
