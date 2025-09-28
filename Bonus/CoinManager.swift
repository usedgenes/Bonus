//
//  CoinManager.swift
//  Bonus
//
//  Created by Lisa Hu on 9/27/25.
//

import Foundation
import Combine // ✅ Required for ObservableObject

class CoinManager: ObservableObject {
    @Published var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: "userCoins")
        }
    }

    init() {
        self.coins = UserDefaults.standard.integer(forKey: "userCoins")
    }

    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }

    func addCoins(_ amount: Int) {
        coins += amount
    }

    func resetCoins() {
        coins = 0
    }
}
