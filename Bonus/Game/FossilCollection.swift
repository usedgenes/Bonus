//
//  FossilCollection.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import SwiftUI
import Combine

class FossilCollection: ObservableObject {
    @Published var fossils: [Fossil] {
        didSet {
            save()
        }
    }
    @Published var hasShownCongrats: Bool = false

    init(fossils: [Fossil]) {
        self.fossils = fossils
        load() // Try loading saved fossils first
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

    // MARK: - Persistence
    private func getFileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("fossils.json")
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(fossils)
            try data.write(to: getFileURL())
            print("Fossils saved.")
        } catch {
            print("Failed to save fossils: \(error)")
        }
    }

    func load() {
        let url = getFileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            let data = try Data(contentsOf: url)
            fossils = try JSONDecoder().decode([Fossil].self, from: data)
            print("Fossils loaded.")
        } catch {
            print("Failed to load fossils: \(error)")
        }
    }
}
