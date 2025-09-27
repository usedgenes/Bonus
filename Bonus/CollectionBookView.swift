import SwiftUI

struct CollectionBookView: View {
    
    @EnvironmentObject var fossilCollection: FossilCollection
    
    @State private var showCongrats = false
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            VStack(spacing: screenHeight*0.02) {
                // Header
                ZStack {
                    HStack { Spacer() }
                        .frame(width: screenWidth*0.87)
                        .border(Color.green, width:2)
                    
                    Text("Collection Book")
                        .font(.title)
                        .foregroundColor(.brown)
                }
                
                // Main image
                if fossilCollection.foundCount >= 18 {
                    Image(systemName: "eraser")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.75, height: screenHeight*0.18)
                } else {
                    Image("leftArm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.75, height: screenHeight*0.18)
                }
                
                // Fossil count
                Text("Brachiosaurus Fossils (\(fossilCollection.foundCount)/18)")
                    .font(.title2)
                    .foregroundColor(.brown)
                
                // Fossil grid
                ScrollView {
                    VStack(spacing: screenHeight*0.02) {
                        ForEach(0..<9, id: \.self) { rowIndex in
                            HStack(spacing: screenHeight*0.02) {
                                createFossilCard(fossil: fossilCollection.getFossils()[rowIndex*2])
                                createFossilCard(fossil: fossilCollection.getFossils()[rowIndex*2+1])
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .onAppear {
                if fossilCollection.foundCount >= 18 && !fossilCollection.hasShownCongrats {
                    showCongrats = true
                    fossilCollection.hasShownCongrats = true
                }
            }
            
            // Congratulations overlay
            if showCongrats {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("🎉 Congratulations! 🎉")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("You found all 18 Brachiosaurus fossils!")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        withAnimation { showCongrats = false }
                    }) {
                        Text("Close")
                            .font(.title2)
                            .bold()
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.green)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.8))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
    }
    
    // MARK: - Fossil Card
    func createFossilCard(fossil: Fossil) -> some View {
        // Compute text outside the VStack
        let rarityText = fossil.rarity.rawValue.prefix(1).uppercased() + fossil.rarity.rawValue.dropFirst()
        
        return VStack(spacing: screenHeight*0.01) {
            if fossil.found {
                // Name
                Text(fossil.name.uppercased())
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: screenWidth*0.37, height: screenHeight*0.27*0.27)
                
                // Image
                Image(fossil.picture)
                    .resizable()
                    .scaledToFill()
                    .frame(height: screenHeight*0.27*0.53)
                    .cornerRadius(10)
                
                // Rarity
                Text(rarityText)
                    .font(.system(size: 21))
                    .foregroundColor(.black)
                    .frame(width: screenWidth*0.37, height: screenHeight*0.27*0.20)
                
            } else {
                Text("""
                Undiscovered
                ...
                """)
                .font(.system(size: 22))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(width: screenWidth*0.41, height: screenHeight*0.27)
        .background(fossil.rarityColor.opacity(0.6))
        .cornerRadius(8)
    }
}

struct CollectionBookView_Preview: PreviewProvider {
    static var previews: some View {
        CollectionBookView()
            .environmentObject(FossilCollection(fossils: sharedFossils))
    }
}
