//
//  FossilCollection.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import SwiftUI
import Combine

class FossilCollection: ObservableObject {
    @Published var fossils: [Fossil]

    init(fossils: [Fossil]) {
        self.fossils = fossils
    }

    func markFound(fossilName: String) {
        if let index = fossils.firstIndex(where: { $0.name == fossilName }) {
            fossils[index].found = true
        }
    }

    var foundFossils: [Fossil] {
        fossils.filter { $0.found }
    }
    
    var foundCount: Int {
        fossils.filter { $0.found }.count
    }
    
    func getFossils() -> [Fossil] {
        return fossils
    }
    
}
