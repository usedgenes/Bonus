//
//  CustomerStuff.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//
import SwiftUI
import Combine

class CustomerTests : ObservableObject{
    let client = NSEClient.sharedInstance
    
    init() {
        print("hi")
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")

        // Launch async work at init
        Task {
            await testPostCustomer()
        }
    }
    
    func testGetCustomers() async {
        do {
            if let customers = try await CustomerRequest().getCustomers() {
                if customers.count > 0 {
                    let customer = customers[0]
                    print(customers)
                    await self.testGetCustomer(customerId: customer.customerId)
                } else {
                    print("No customers found")
                }
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func testGetCustomer(customerId: String) async {
        do {
            if let customer = try await CustomerRequest().getCustomer(customerId) {
                print(customer)
                await self.testGetCustomer(accountId: "5cf88f206759394351beee6b")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func testGetCustomer(accountId: String) async  {
        do {
            if let customer = try await CustomerRequest().getCustomerFromAccountId(accountId) {
                print(customer)
                await self.testPostCustomer()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func testPostCustomer() async {
        do {
            let address = Address(streetName: "Street", streetNumber: "1", city: "City", state: "VA", zipCode: "12345")
            let customerToCreate = CustomerPostData(firstName: "Andrew", lastName: "Dunetz", address: address)
            if let customerPostResponse = try await CustomerRequest().postCustomer(customerToCreate) {
                let message = customerPostResponse.message
                let customerCreated = customerPostResponse.objectCreated
                print("\(message): \(customerCreated)")
                await self.testPutCustomer(customerId: customerCreated!.customerId)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func testPutCustomer(customerId: String) async {
        do {
            let address = Address(streetName: "Street", streetNumber: "2", city: "City", state: "MD", zipCode: "54321")
            let customerToUpdate = CustomerPutData(address: address)
            if let customerPutResponse = try await CustomerRequest().putCustomer(customerId, customerToUpdate) {
                let message = customerPutResponse.message
                print("\(message)")
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
