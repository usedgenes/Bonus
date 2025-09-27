//
//  BonusApp.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI
import Combine

@main
struct BonusApp: App {
    @StateObject var customer = CustomerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(customer)
        }
    }
}
