//
//  CollectionBookView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//
import SwiftUI

struct CollectionBookView: View {
    @State private var counter = 0

    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        VStack(spacing: 20) {
            ZStack{
                HStack{
                    Button(action: {
                        print("Go Back")
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.brown)
                    }
                    Spacer()
                }
                .frame(width: screenWidth*0.87)
                .border(Color.green, width:2)
                Text("Collection Book")
                    .font(.title)
                    .foregroundColor(.brown)
            }
            Image(systemName: "eraser")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.75, height: screenHeight*0.2)
            Text("Collected Fossils")
                .font(.title2)
                .foregroundColor(.brown)
            
            ScrollView {
                        VStack(spacing: 20) { // spacing between HStacks
                            ForEach(0..<10) { _ in
                                HStack(spacing: 20) { // spacing between images
                                    Image(systemName: "eraser") // first eraser image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenWidth*0.35, height: screenHeight*0.25)
                                        .border(Color.green, width: 2)
                                    
                                    Image(systemName: "eraser") // second eraser image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenWidth*0.35, height: screenHeight*0.25)
                                        .border(Color.green, width: 2)
                                }
                            }
                        }
                        .padding()
                    }
        }
        .padding()
    }
}

struct CollectionBookView_Preview: PreviewProvider {
    static var previews: some View {
        CollectionBookView()
    }
}

