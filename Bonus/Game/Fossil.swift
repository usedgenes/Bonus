//
//  Fossil.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation

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
}

enum Rarity: String, Codable {
    case common
    case uncommon
    case rare
    case legendary
}
