//
//  Plot.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation

enum PlotState: Codable, Equatable {
    case untouched
    case dug
    case foundItem(String)

    static func == (lhs: PlotState, rhs: PlotState) -> Bool {
        switch (lhs, rhs) {
        case (.untouched, .untouched),
             (.dug, .dug):
            return true
        case let (.foundItem(l), .foundItem(r)):
            return l == r
        default:
            return false
        }
    }

}

struct Plot: Codable, Identifiable {
    var id = UUID()
    var state: PlotState
    var fossil: Fossil?
}
