//
//  SettingsView.swift
//  Bonus
//
//  Created by Judy Hsu on 9/27/25.
//

import SwiftUI


struct SettingsView: View {
    @State private var showingUserInfo = false
    @State private var showingAccountInfo = false
    @State private var showingWithdrawalInfo = false
    @State private var transactionAmount = "100"
    @EnvironmentObject var customer: CustomerStore
    @EnvironmentObject var budgetModel: BudgetModel
    @State private var showCalculator = false
    @State private var showError = false
    @State private var monthlyBudget = "3000"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Settings")
                    .font(Font.largeTitle)
                    .padding(.top)
                Divider()
                
                Button {
                    showingUserInfo = true
                } label: {
                    Label("Enter User Info", systemImage: "person.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                
                Button {
                    showingAccountInfo = true
                } label: {
                    Label("Create Account", systemImage: "plus.circle.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                .disabled(customer.customer == nil)
                
                VStack(spacing: 0) {
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        if let amount = Double(transactionAmount) {
                            Task {
                                await customer.postWithdrawal(medium: TransactionMedium.Balance, amount: amount)
                            }
                        }
                    } label: {
                        Label("Create Transaction", systemImage: "plus.circle.fill")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, minHeight: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                    .disabled(customer.account == nil)
                    
                    TextField("Enter amount", text: $transactionAmount)
                        .keyboardType(.decimalPad)
                        .font(.title3)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .disabled(customer.account == nil)
                }
                
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingUserInfo) {
                PersonFormView()
            }
            .sheet(isPresented: $showingAccountInfo) {
                AccountCreationView()
            }
            
            VStack {
//                Button() {
//                    if (showCalculator) {
//                        Task {
//                            let account = await customer.getAccount()
//                            if (Int(budgetModel.monthlyBudget) > account!.balance)  {
//                                showError = true
//                            } else {
//                                showCalculator.toggle()
//                            }
//                        }
//
//                    } else {
//                        showCalculator.toggle()
//                    }
//                } label: {
//                    Label(showCalculator ? "Click here when done" : "Enter new monthly budget", systemImage: "dollarsign.circle.fill")
//                        .font(.title2.bold())
//                        .frame(maxWidth: .infinity, minHeight: 60)
//                }
//                .buttonStyle(.borderedProminent)
//                .disabled(customer.account == nil)
                
                VStack(spacing: 0) {
                    Button {
                        if (showCalculator) {
                            Task {
                                let account = await customer.getAccount()
                                if (Int(monthlyBudget)! > account!.balance)  {
                                    showError = true
                                } else {
                                    budgetModel.monthlyBudget = Double(monthlyBudget)!
                                }
                            }
                        } else {
                            showCalculator.toggle()
                        }
                    } label: {
                        Label("Change Monthly Salary", systemImage: "plus.circle.fill")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, minHeight: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                    .disabled(customer.account == nil)
                    
                    TextField("Enter amount", text: $monthlyBudget)
                        .keyboardType(.decimalPad)
                        .font(.title3)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .disabled(customer.account == nil)
                }

                Button {
                    Task {
                        await customer.deleteCustomers()
                    }
                } label: {
                    Label("Delete User Info", systemImage: "trash.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                .tint(.red)
                
                Button {
                    Task {
                        await customer.deleteAccounts()
                    }
                } label: {
                    Label("Delete Account Info", systemImage: "trash.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))
                .tint(.red)
                
                Button() {
                    if let url = URL(string: "https://www.capitalone.com/bank/money-management/ways-to-save/balanced-family-budget/") {
                        UIApplication.shared.open(url)
                    }
                }
                label: {
                    Label("Learn how to budget", systemImage: "link")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .buttonStyle(PressableButtonStyle(pressedColor: .black.opacity(0.2)))

            }
            .padding(.horizontal)
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error Setting Monthly Budget"),
                    message: Text("Budget Exceeds Current Account Balance!")
                )
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(BudgetModel())
        .environmentObject(CustomerStore())
}

struct PressableButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat = 0.95
    var pressedColor: Color = Color.gray.opacity(0.3)
    var cornerRadius: CGFloat = 12
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding() // ensure background fills the button
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(configuration.isPressed ? pressedColor : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)

    }
}

