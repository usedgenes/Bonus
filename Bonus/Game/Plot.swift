//
//  Plot.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation

enum PlotState: Codable {
    case untouched
    case dug
    case foundItem(String)
    
    // Codable implementation (as shown earlier)
    // ...
}

struct Plot: Codable, Identifiable {
    var id = UUID()
    var state: PlotState
}
