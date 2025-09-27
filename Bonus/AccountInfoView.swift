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
    @State private var showingForm = false
    @EnvironmentObject var customer: CustomerStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Button("Enter User Info") {
                    showingForm = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Create Account") {
                    print("Button tapped!")
                }
                // Disable if customer is nil
                .disabled(customer.customer == nil)
                
                Button(action: {
                    Task {
                        await customer.deleteCustomers()
                    }
                }) {
                    Text("Delete Data")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Account Info")
            .sheet(isPresented: $showingForm) {
                PersonFormView()
            }
            
        }
    }
}

#Preview {
    AccountInfoView()
}
