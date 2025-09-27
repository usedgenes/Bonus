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
    @StateObject private var fossilCollection = FossilCollection(fossils: sharedFossils)
    @EnvironmentObject var budgetModel: BudgetModel
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fossilCollection)
                .environmentObject(budgetModel)
                .environmentObject(customer)
        }
    }
}
