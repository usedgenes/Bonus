//
//  Fossil.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation
import SwiftUI

struct Fossil: Codable, Identifiable {
    var id: UUID
    let name: String
    let rarity: Rarity
    let picture: String
    var found: Bool

    init(name: String, rarity: Rarity, picture: String, found: Bool) {
        self.id = UUID()
        self.name = name
        self.rarity = rarity
        self.picture = picture
        self.found = found
    }
    
    var rarityColor: Color {
        switch self.rarity {
        case .legendary:
            return Color(red: 241/255, green: 196/255, blue: 15/255)
        case .rare:
            return Color(red: 125/255, green: 60/255, blue: 152/255)
        case .uncommon:
            return Color(red: 39/255, green: 174/255, blue: 96/255)
        case .common:
            return Color(red: 195/255, green: 176/255, blue: 145/255)
        }
    }
}

enum Rarity: String, Codable {
    case common
    case uncommon
    case rare
    case legendary
}
