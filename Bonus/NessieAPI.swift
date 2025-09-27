//
//  NessieAPI.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//
import Foundation
import Combine

struct ATM: Decodable, Identifiable {
    let id: String
    let name: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let latitude: Double
    let longitude: Double
}

class NessieAPI: ObservableObject {
    @Published var atms: [ATM] = []
    private let apiKey = "your_api_key_here"
    private let baseURL = "https://api.nessieisreal.com/"

    func fetchATMLocations() {
        guard let url = URL(string: "\(baseURL)atms") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching ATMs: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let atms = try JSONDecoder().decode([ATM].self, from: data)
                DispatchQueue.main.async {
                    self.atms = atms
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
