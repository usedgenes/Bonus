//
//  CustomerStore.swift
//  Bonus
//
//  Created by Eugene on 9/27/25.
//
import SwiftUI
import Combine

class CustomerStore: ObservableObject {
    let client = NSEClient.sharedInstance
    
    init() {
        client.setKey("feed33b75ac75260ba06209bd0bcc809")
    }
    
    @Published var customer: Customer? = nil
    @Published var account: Account? = nil
    
    func postCustomer(firstName: String, lastName: String, streetName: String, streetNumber: String, city: String, state: String, zipCode: String) async {
        do {
            let address = Address(streetName: streetName, streetNumber: streetNumber, city: city, state: state, zipCode: zipCode)
            let customerToCreate = CustomerPostData(
                firstName: firstName,
                lastName: lastName,
                address: address
            )
            if let customerPostResponse = try await CustomerRequest().postCustomer(customerToCreate) {
                let message = customerPostResponse.message
                let customerCreated = customerPostResponse.objectCreated
                print("\(message): \(customerCreated)")
                if let created = customerCreated {
                    customer = created
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteCustomers() async {
        do {
            try await CustomerRequest().deleteCustomers()
        } catch {
            print("❌ Failed to delete customers: \(error)")
        }
    }
    
    func postAccount(customerId: String, accountNumber: String, routingNumber: String, balance: Double) async {
        do {
            let accountToCreate = AccountPostData(
                customerId: customerId,
                accountNumber: accountNumber,
                routingNumber: routingNumber,
                balance: balance
            )
            if let accountPostResponse = try await AccountRequest().postAccount(accountToCreate) {
                let message = accountPostResponse.message
                let accountCreated = accountPostResponse.objectCreated
                print("\(message): \(accountCreated)")
                if let created = accountCreated {
                    account = created
                }
            }
        }
    }
}
