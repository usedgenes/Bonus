//
//  BonusApp.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

@main
struct BonusApp: App {
    @StateObject private var customers = CustomerTests()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(customers)
        }
    }
}
