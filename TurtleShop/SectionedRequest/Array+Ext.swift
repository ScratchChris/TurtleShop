//
//  Array+Ext.swift
//  TurtleShop
//
//  Created by Chris Turner on 27/06/2024.
//

import Foundation

internal extension Array where Iterator.Element: Hashable {
    
    func uniqued() -> [Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
    
}
