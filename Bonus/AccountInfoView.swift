//
//  AccountInfoView.swift
//  Bonus
//
//  Created by Eugene on 9/27/25.
//

import SwiftUI

struct Person {
    var firstName: String = ""
    var lastName: String = ""
}

struct AccountInfoView: View {
    @State private var person: Person? = nil
    @State private var showingUserInfo = false
    @State private var showingAccountInfo = false
    @State private var showingWithdrawalInfo = false
    @State private var transactionAmount = "100"
    @EnvironmentObject var customer: CustomerStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Button {
                    showingUserInfo = true
                } label: {
                    Label("Enter User Info", systemImage: "person.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    showingAccountInfo = true
                } label: {
                    Label("Create Account", systemImage: "plus.circle.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .disabled(customer.customer == nil)
                VStack(spacing: 0) {
                    Button {
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
                    .disabled(customer.account == nil)

                    TextField("Enter amount", text: $transactionAmount)
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
                .buttonStyle(.bordered)
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
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding(.horizontal)
            .padding(.top, 40)
            .navigationTitle("Account Info")
            .sheet(isPresented: $showingUserInfo) {
                PersonFormView()
            }
            .sheet(isPresented: $showingAccountInfo) {
                AccountCreationView()
            }
        }
    }
}

struct AccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoView()
            .environmentObject(CustomerStore()) // inject a store
    }
}
