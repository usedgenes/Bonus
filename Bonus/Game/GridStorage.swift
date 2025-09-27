//
//  GridStorage.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation

class GridStorage {
    static let filename = "digGrid.json"

    static func save(grid: [[Plot]]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(grid)
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try data.write(to: url)
            print("Grid saved to \(url)")
        } catch {
            print("Error saving grid: \(error)")
        }
    }

    static func clear() {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
            print("Grid reset: file deleted.")
        }
    }
    
    static func load() -> [[Plot]]? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let grid = try decoder.decode([[Plot]].self, from: data)
            return grid
        } catch {
            print("Error loading grid: \(error)")
            return nil
        }
    }

    private static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
