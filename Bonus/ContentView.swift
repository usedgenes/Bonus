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
        NavigationStack {
            ZStack {
                
                VStack {
                    HStack {
                        NavigationLink(destination: CollectionBookView()) {
                            Image(systemName: "book.closed.fill")
                                .font(.largeTitle)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.largeTitle)
                        }
                    }
                    
//                    Image("dirt") // this is a placeholder image lol
//                        .resizable()
//                        .scaledToFill()
//                        .ignoresSafeArea()
                    
                    Spacer()
                }
                .padding()
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

