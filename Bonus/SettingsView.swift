
//
//  SettingsView.swift
//  Bonus
//
//  Created by Judy Hsu on 9/27/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var budgetModel: BudgetModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Budget")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            Text("Monthly Salary: \(monthlyBudget, specifier: "%.2f")")
                .font(.title2)
            
        }
    }
}

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
