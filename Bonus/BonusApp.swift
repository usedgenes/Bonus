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
    @StateObject var budgetModel = BudgetModel()
    @StateObject private var fossilCollection = FossilCollection(fossils: sharedFossils)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fossilCollection)
                .environmentObject(budgetModel)
                .environmentObject(customer)
        }
    }
}
