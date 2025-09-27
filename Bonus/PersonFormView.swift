//
//  PersonFormView.swift
//  Bonus
//
//  Created by Eugene on 9/27/25.
//
import SwiftUI

struct PersonFormView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var customer: CustomerStore

    @State private var firstName: String = "John"
    @State private var lastName: String = "Doe"
    @State private var streetNumber: String = "12345"
    @State private var streetName: String = "67th Street"
    @State private var city: String = "Springfield"
    @State private var state: String = "IL"
    @State private var zipCode: String = "99999"

    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                        .textInputAutocapitalization(.words)
                    TextField("Last Name", text: $lastName)
                        .textInputAutocapitalization(.words)
                }
                
                Section(header: Text("Address")) {
                    TextField("Street Number", text: $streetNumber)
                        .keyboardType(.numberPad)
                    TextField("Street Name", text: $streetName)
                        .textInputAutocapitalization(.words)
                    TextField("City", text: $city)
                        .textInputAutocapitalization(.words)
                    TextField("State (e.g. WA)", text: $state)
                        .textInputAutocapitalization(.characters)
                        .disableAutocorrection(true)
                    TextField("ZIP Code", text: $zipCode)
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
            .navigationTitle("User Form")
        }
    }
    
    private func saveData() async {
        await customer.postCustomer(firstName: firstName, lastName: lastName, streetName: streetName, streetNumber: streetNumber, city: city, state: state, zipCode: zipCode)
    }
}

struct PersonFormView_Previews: PreviewProvider {
    static var previews: some View {
        PersonFormView()
    }
}
