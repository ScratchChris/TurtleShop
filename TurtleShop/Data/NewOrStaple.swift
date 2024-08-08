//
//  NewOrStaple.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import Foundation

enum NewOrStaple: Int {
    case new = 1
    case staple = 2
    case neither = 3
}

extension Item {
    var itemNewOrStaple: NewOrStaple {
        get {
            return NewOrStaple(rawValue: Int(self.newOrStaple)) ?? .new
        }
        set {
            self.status = Int16(newValue.rawValue)
        }
    }
}
