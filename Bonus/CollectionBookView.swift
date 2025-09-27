import SwiftUI


struct CollectionBookView: View {
    
    @EnvironmentObject var fossilCollection: FossilCollection
    
    let screenWidth = UIScreen.main.bounds.width
    
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
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
            
            Text("Brachiosaurus Fossils")
                .font(.title2)
                .foregroundColor(.brown)
            
            
            
            ScrollView {
                
                VStack(spacing: 20) { // spacing between HStacks
                    ForEach(0..<9, id: \.self) { rowIndex in
                        HStack(spacing: 20) { // spacing between images
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
        VStack(spacing: 10) {
            if fossil.found {
                Text(fossil.name)
                    .font(.title3)
                    .foregroundColor(.brown)
                    .multilineTextAlignment(.center)
                
                Image(fossil.picture)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(10)
                
                Text(fossil.rarity.rawValue.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.brown)
                
            } else {
                Text("Undiscovered ...")
                    .foregroundColor(.brown)
                    .multilineTextAlignment(.center)
            }
        }
        
        .padding()
        .frame(width: screenWidth*0.35, height: screenHeight*0.25)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(15)
        
    }
    
}


struct CollectionBookView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        CollectionBookView()
        
    }
    
}

