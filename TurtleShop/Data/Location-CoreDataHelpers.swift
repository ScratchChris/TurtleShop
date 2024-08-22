//
//  Location-CoreDataHelpers.swift
//  TurtleShop
//
//  Created by Chris Turner on 13/08/2024.
//

import Foundation

extension Location {
    var locationID: UUID {
        id ?? UUID()
    }
    
    var locationName: String {
        get { name ?? "" }
        set { name = newValue }
    }
    
    var locationItems: [Item] {
        let result = items?.allObjects as? [Item] ?? []
        return result.sorted()
    }
    
    static var example: Location {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let location = Location(context: viewContext)
        location.id = UUID()
        location.name = "Example Location"
        return location
    }
}

extension Location: Comparable {
    public static func <(lhs: Location, rhs: Location) -> Bool {
        let left = lhs.locationName.localizedLowercase
        let right = rhs.locationName.localizedLowercase
        
        if left == right {
            return lhs.locationID.uuidString < rhs.locationID.uuidString
        } else {
            return left < right
        }
    }
}

