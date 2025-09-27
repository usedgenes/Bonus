//
//  SettingsView.swift
//  Bonus
//
//  Created by Judy Hsu on 9/27/25.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var budgetModel: BudgetModel
    @State private var showCalculator = false

    var body: some View {
        VStack {
            Text("Settings")
                .font(Font.largeTitle)
                .padding()
            
            Button (action: {
                showCalculator.toggle()
            }) {
                Text(showCalculator ? "Click here when done" : "Enter new monthly salary")
                    .font(.title3)
                    .frame(width: 350, height: 75, alignment: .center)
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
        
            if showCalculator {
                Text("Monthly Budget: \(budgetModel.monthlyBudget, specifier: "%.0f")")
                    .font(Font.title)
                
                ForEach([[1, 2, 3], [4, 5, 6], [7, 8, 9]], id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { number in
                            Button(action: {
                                budgetModel.monthlyBudget = budgetModel.monthlyBudget * 10 + number
                            }) {
                                Text("\(number, specifier: "%.0f")")
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                HStack {
                    Button("0") {
                        budgetModel.monthlyBudget = budgetModel.monthlyBudget * 10
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Clear") {
                        budgetModel.monthlyBudget = 0.0
                    }
                    .frame(width: 130, height: 60)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            
            Link("Learn how to budget", destination: URL(string: "https://www.capitalone.com/bank/money-management/ways-to-save/balanced-family-budget/")!)
                .font(.title3)
                .frame(width: 350, height: 75, alignment: .center)
                .background(.white)
                .cornerRadius(8)
                .shadow(radius: 3)
                
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(BudgetModel())
}
