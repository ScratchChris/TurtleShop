//
//  ItemStatus.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import Foundation

enum ItemStatus: Int {
    case unselected = 1
    case needed = 2
    case unneeded = 3
}

extension Item {
    var itemStatus: ItemStatus {
        get {
            return ItemStatus(rawValue: Int(self.status)) ?? .unselected
        }
        set {
            self.status = Int16(newValue.rawValue)
        }
    }
}
