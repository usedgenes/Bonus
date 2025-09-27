import SwiftUI


struct CollectionBookView: View {
    
    @EnvironmentObject var fossilCollection: FossilCollection
    
    let screenWidth = UIScreen.main.bounds.width
    
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        VStack(spacing: screenHeight*0.02) {
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
                .frame(width: screenWidth*0.75, height: screenHeight*0.18)
            
            Text("Brachiosaurus Fossils")
                .font(.title2)
                .foregroundColor(.brown)
            
            
            
            ScrollView {
                
                VStack(spacing: screenHeight*0.02) { // spacing between HStacks
                    ForEach(0..<9, id: \.self) { rowIndex in
                        HStack(spacing: screenHeight*0.02) { // spacing between images
                            createFossilCard(fossil: sharedFossils[rowIndex*2])
                            createFossilCard(fossil: sharedFossils[rowIndex*2+1])
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    func createFossilCard(fossil: Fossil) -> some View {
        VStack(spacing: screenHeight*0.01) {
            if fossil.found {
                Text(fossil.name)
                    .font(.title3)
                    .foregroundColor(.brown)
                    .multilineTextAlignment(.center)
                    .lineLimit(2) // allows up to 2 lines
                    .fixedSize(horizontal: false, vertical: true)
                
                Image(fossil.picture)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(10)
                
                Text(fossil.rarity.rawValue.uppercased())
                    .font(.system(size: 21))
                    .foregroundColor(.brown)
                
            } else {
                Text("Undiscovered ...")
                    .foregroundColor(.brown)
                    .multilineTextAlignment(.center)
            }
        }
        
        .padding()
        .frame(width: screenWidth*0.41, height: screenHeight*0.27)
        .background(fossilCardColor(fossil: fossil))
        .cornerRadius(8)
        
    }
    
    func fossilCardColor(fossil: Fossil) -> Color {
        switch fossil.rarity {
        case .legendary:
            return Color.yellow.opacity(0.3)
        case .rare:
            return Color.purple.opacity(0.3)
        case .uncommon:
            return Color.green.opacity(0.3)
        case .common:
            return Color.brown.opacity(0.3)
        }
    }
}


struct CollectionBookView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        CollectionBookView()
        
    }
    
}

