import SwiftUI


struct CollectionBookView: View {
    
    @EnvironmentObject var fossilCollection: FossilCollection
    
    let screenWidth = UIScreen.main.bounds.width
    
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        VStack(spacing: screenHeight*0.02) {
            ZStack{
                HStack{
                    Spacer()
                }
                .frame(width: screenWidth*0.87)
                .border(Color.green, width:2)
                
                Text("Collection Book")
                    .font(.title)
                    .foregroundColor(.brown)
            }
            
            if (fossilCollection.foundCount >= 18) {
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
            

            
            Text("Brachiosaurus Fossils (" + String(fossilCollection.foundCount) + "/18)")
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
                VStack () {
                    Spacer()
                    Text(fossil.name.uppercased())
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2) // allows up to 2 lines
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: screenWidth*0.37, height: screenHeight*0.27*0.27)
                //.border(Color.black, width:2)
                
                Image(fossil.picture)
                    .resizable()
                    .scaledToFill()
                    .frame(height: screenHeight*0.27*0.53)
                    .cornerRadius(10)
                
                VStack {
                    let fossilRarityString = String(fossil.rarity.rawValue)
                    Text(String(fossilRarityString.prefix(1).uppercased() + fossilRarityString.dropFirst()))
                        .font(.system(size: 21))
                        .foregroundColor(.black)
                    
                    Spacer()
                        
                }.frame(width: screenWidth*0.37, height: screenHeight*0.27*0.20)
                
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

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


struct CollectionBookView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        CollectionBookView()
            .environmentObject(FossilCollection(fossils: sharedFossils))
        
    }
    
}


