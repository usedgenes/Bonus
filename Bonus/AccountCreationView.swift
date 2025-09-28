//
//  AccountCreationView.swift
//  Bonus
//
//  Created by Eugene on 9/27/25.
//

import SwiftUI

struct AccountCreationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var customer: CustomerStore

    @State private var accountType: AccountType = AccountType.Checking
    @State private var nickname: String = "Bank Account"
    @State private var balance: String = "5000"
    @State private var accountNumber: String = "4003830171874018"

    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Account Info")) {
                    TextField("Name", text: $nickname)
                        .textInputAutocapitalization(.words)
                    TextField("Balance", text: $balance)
                        .keyboardType(.numberPad)
                    TextField("Account Number", text: $accountNumber)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await saveData()
                        }
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Save")
                                .bold()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Create a Bank Account")
        }
    }
    
    private func saveData() async {
        await customer.postAccount(accountType: accountType, nickname: nickname, rewards: 0, balance: Int(balance)!, accountNumber: accountNumber)
    }
}

struct AccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountCreationView()
            .environmentObject(CustomerStore())
    }
}
