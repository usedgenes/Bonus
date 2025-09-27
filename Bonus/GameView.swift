//
//  GameView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

struct GameView: View {
    @State private var counter = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, SwiftUI!")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            Text("Counter: \(counter)")
                .font(.title2)
            
            Button(action: {
                counter += 1
            }) {
                Text("Increment Counter")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            HStack {
                NavigationLink {
                    CollectionBookView()
                } label: {
                    Text("Collection Book")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
        }
        .padding()

    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

