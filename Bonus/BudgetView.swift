//
//  BudgetView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

struct BudgetView: View {
    @State private var monthlyBudget = 0
//    @Binding var isShowingCalculator: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Budget")
                .font(.largeTitle)
                .foregroundColor(.blue)

            Text("Monthly Budget: \(monthlyBudget)")
                .font(.title2)
            HStack {
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 1
                }) {
                    Text("1")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 2
                }) {
                    Text("2")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 3
                }) {
                    Text("3")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            
            HStack {
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 4
                }) {
                    Text("4")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 5
                }) {
                    Text("5")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 6
                }) {
                    Text("6")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            
            HStack {
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 7
                }) {
                    Text("7")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 8
                }) {
                    Text("8")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    monthlyBudget = monthlyBudget * 10 + 9
                }) {
                    Text("9")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
            }
            Spacer()
        }
        .padding()
    }
}

struct BudgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetView()
    }
}
