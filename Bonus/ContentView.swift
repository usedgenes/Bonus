//
//  ContentView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var api = NessieAPI()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Budget")) {
                    NavigationLink("Budget", destination: BudgetView())
                }
                Section(header: Text("Game")) {
                    NavigationLink("Game", destination: GameView())
                    
                }
            }
            .navigationBarTitle("BONU$")
            List(api.atms) { atm in
                VStack(alignment: .leading) {
                    Text(atm.name)
                        .font(.headline)
                    Text("\(atm.address), \(atm.city), \(atm.state) \(atm.zip)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("ATMs")
            .onAppear {
                api.fetchATMLocations()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}


extension View {
    func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

