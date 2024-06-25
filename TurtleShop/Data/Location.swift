//
//  Location.swift
//  TurtleShop
//
//  Created by Chris Turner on 25/06/2024.
//

import Foundation
import SwiftData

@Model
class Location {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
