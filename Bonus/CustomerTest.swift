import SwiftUI
import Combine

@MainActor // Ensure any UI-related updates happen on the main thread
class CustomerTest: ObservableObject {
    let client = NSEClient.sharedInstance
    @Published var lastCustomer: Customer? = nil
    
    init() {
        client.setKey("bca7093ce9c023bb642d0734b29f1ad2")
        // Do NOT call async here
    }
    
    func start() async {
        await testPostCustomer()
    }
    
    func testGetCustomers() async {
        do {
            if let customers = try await CustomerRequest().getCustomers() {
                if !customers.isEmpty {
                    let customer = customers[0]
                    print(customers)
                    await testGetCustomer(customerId: customer.customerId)
                } else {
                    print("No customers found")
                }
            }
        } catch {
            print(error)
        }
    }
    
    func testGetCustomer(customerId: String) async {
        do {
            if let customer = try await CustomerRequest().getCustomer(customerId) {
                print(customer)
                await testGetCustomer(accountId: "5cf88f206759394351beee6b")
            }
        } catch {
            print(error)
        }
    }
    
    func testGetCustomer(accountId: String) async {
        do {
            if let customer = try await CustomerRequest().getCustomerFromAccountId(accountId) {
                print(customer)
                await testPostCustomer()
            }
        } catch {
            print(error)
        }
    }
    
    func testPostCustomer() async {
        do {
            let address = Address(
                streetName: "Street",
                streetNumber: "1",
                city: "City",
                state: "VA",
                zipCode: "12345"
            )
            let customerToCreate = CustomerPostData(
                firstName: "FFFFFFFFFfffFFFFFFF",
                lastName: "Dunetz",
                address: address
            )
            if let customerPostResponse = try await CustomerRequest().postCustomer(customerToCreate) {
                let message = customerPostResponse.message
                let customerCreated = customerPostResponse.objectCreated
                print("\(message): \(customerCreated)")
                if let created = customerCreated {
                    lastCustomer = created
                    await testPutCustomer(customerId: created.customerId)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func testPutCustomer(customerId: String) async {
        do {
            let address = Address(
                streetName: "Street",
                streetNumber: "2",
                city: "City",
                state: "MD",
                zipCode: "54321"
            )
            let customerToUpdate = CustomerPutData(address: address)
            if let customerPutResponse = try await CustomerRequest().putCustomer(customerId, customerToUpdate) {
                let message = customerPutResponse.message
                print("\(message)")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllCustomers() async {
        do {
            // 1. Get all customers
            if let customers = try await CustomerRequest().getCustomers() {
                if customers.isEmpty {
                    print("No customers to delete")
                    return
                }
                
                // 2. Loop through each customer and delete
                for customer in customers {
                    await deleteCustomer(customerId: customer.customerId)
                }
                
                print("All customers deleted")
            }
        } catch {
            print("Error fetching customers:", error)
        }
    }
    
    // Reuse your existing deleteCustomer method
    func deleteCustomer(customerId: String) async {
        let apiKey = "bca7093ce9c023bb642d0734b29f1ad2"
        guard let url = URL(string: "http://api.nessieisreal.com/customers/\(customerId)?key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Deleted customer \(customerId)")
            } else {
                print("Failed to delete customer \(customerId)")
            }
        } catch {
            print("Error deleting customer \(customerId):", error)
        }
    }
    
}
