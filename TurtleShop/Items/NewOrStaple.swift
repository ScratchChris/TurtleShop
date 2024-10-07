//
//  NewOrStaple.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import Foundation
import SwiftUI

enum NewOrStaple: Int {
    case new = 1
    case staple = 2
    case neither = 3
    
    var isStaple: Bool { self == .staple }
}

extension Item {
    var itemNewOrStaple: NewOrStaple {
        get {
            return NewOrStaple(rawValue: Int(self.newOrStaple)) ?? .new
        }
        set {
            self.newOrStaple = Int16(newValue.rawValue)
        }
    }
    

}

extension Binding {
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> Binding<NewValue> {
        Binding<NewValue>(get: { transform(wrappedValue) }, set: { _ in })
    }
}
