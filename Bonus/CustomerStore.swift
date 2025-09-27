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
    @Published var withdrawal: Withdrawal? = nil
    var customerId = "-1"
    
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
                    customerId = customer!.customerId
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
    
    func deleteAccounts() async {
        do {
            try await AccountRequest().deleteAccounts()
        } catch {
            print("❌ Failed to delete customers: \(error)")
        }
    }
    
    func postAccount(accountType: AccountType, nickname: String, rewards: Int, balance: Int, accountNumber: String? = nil) async {
        do {
            let accountToCreate = AccountPostData(
                accountType: accountType,
                nickname: nickname,
                rewards: 0,
                balance: balance,
                accountNumber: accountNumber
            )
            if let accountPostResponse = try await AccountRequest().postAccount(customerId, accountToCreate) {
                let message = accountPostResponse.message
                let accountCreated = accountPostResponse.objectCreated
                print("\(message): \(accountCreated)")
                if let created = accountCreated {
                    account = created
                }
            }
        } catch {
            print(error)
        }
    }
    
    func postWithdrawal(medium: TransactionMedium, transactionDate: String? = nil, amount: Double, status: TransferStatus? = nil, description: String? = nil) async {
        do {
            let withdrawalToCreate = WithdrawalPostData(
                medium: medium,
                transactionDate: transactionDate,
                amount: amount,
                status: TransferStatus.Completed,
                description: description
            )
            if let withdrawalPostResponse = try await WithdrawalRequest().postWithdrawal(account!.accountId, withdrawalToCreate) {
                let message = withdrawalPostResponse.message
                let withdrawalCreated = withdrawalPostResponse.objectCreated
                print("\(message): \(withdrawalCreated)")
                if let created = withdrawalCreated {
                    withdrawal = created
                }
            }
        } catch {
            print(error)
            print(customerId)
        }
    }
}
