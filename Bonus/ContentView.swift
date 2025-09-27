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
        TabView {
            CollectionBookView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Collection")
                }
            BudgetView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Budget")
                }
            GameView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Explore")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
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

