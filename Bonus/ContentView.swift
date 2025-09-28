//
//  ContentView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedTab = 3
    var body: some View {
        TabView(selection: $selectedTab) {
            CollectionBookView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Collection")
                }
                .tag(0)
            
            NavigationStack {
                GameView(selectedTab: $selectedTab)
            }
                .tabItem {
                Image(systemName: "gamecontroller")
                Text("Explore")
                }
                .tag(2)
            
            BudgetView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Budget")
                }
                .tag(1)
            
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FossilCollection(fossils: sharedFossils))
            .environmentObject(BudgetModel())
    }
}

extension View {
    func hideKeyboardWhenTappedAround() -> some View  {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

