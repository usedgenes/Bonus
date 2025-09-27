//
//  ContentView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
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

