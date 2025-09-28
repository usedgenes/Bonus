//
//  GameView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

let sharedFossils: [Fossil] = [
    Fossil(name: "Skull", rarity: .legendary, picture: "skull", found: false),
    Fossil(name: "Neck", rarity: .legendary, picture: "neck", found: false),
    Fossil(name: "Left Claw", rarity: .rare, picture: "leftClaw", found: false),
    Fossil(name: "Right Claw", rarity: .rare, picture: "rightClaw", found: false),
    Fossil(name: "Upper Tail", rarity: .rare, picture: "upperTail", found: false),
    Fossil(name: "Lower Tail", rarity: .rare, picture: "lowerTail", found: false),
    Fossil(name: "Upper Left Ribcage", rarity: .uncommon, picture:"upperLeftRib", found: false),
    Fossil(name: "Upper Right Ribcage", rarity: .uncommon, picture:"upperRightRib", found: false),
    Fossil(name: "Lower Left Ribcage", rarity: .uncommon, picture:"lowerLeftRib", found: false),
    Fossil(name: "Lower Right Ribcage", rarity: .uncommon, picture:"lowerRightRib", found: false),
    Fossil(name: "Left Thighbone", rarity: .uncommon, picture:"leftThigh", found: false),
    Fossil(name: "Right Thighbone", rarity: .uncommon, picture: "rightThigh", found: false),
    Fossil(name: "Left Shinbone", rarity: .common, picture: "leftShinbone", found: false),
    Fossil(name: "Right Shinbone", rarity: .common, picture: "rightShinbone", found: false),
    Fossil(name: "Left Foot", rarity: .common, picture: "leftFoot", found: false),
    Fossil(name: "Right Foot", rarity: .common, picture: "rightFoot", found: false),

    Fossil(name: "Left Arm", rarity: .common, picture: "leftArm", found: false),
    Fossil(name: "Right Arm", rarity: .common, picture: "rightArm", found: false)
]

struct GameView: View {
    @Binding var selectedTab: Int
    @State private var foundFossil: Fossil? = nil
    @State private var showInsufficientCoinsPopup = false
    @State private var isFlashing = false
    @EnvironmentObject var coinManager: CoinManager
    @EnvironmentObject var fossilCollection: FossilCollection
    enum GameNavigation: Hashable {
        case collectionBook
    }

    @State private var navigationPath = NavigationPath()
    let columns = 6
    let rows = 6

    @State var grid: [[Plot]] = Array(
        repeating: Array(repeating: Plot(state: .untouched, fossil: nil), count: 6),
        count: 6
    )
    var body: some View {
        let layout = Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image("grassBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Ceratosaurus Dig Site: \(completionPercentage())% complete")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        Text("Click to dig (costs 10🟡) | You have \(coinManager.coins)🟡")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .opacity(isFlashing ? 1 : 1)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .onAppear {
                        isFlashing = true
                    }
                    
                    
                    LazyVGrid(columns: layout, spacing: 2) {
                        ForEach(0..<(rows * columns), id: \.self) { index in
                            let row = index / columns
                            let col = index % columns
                            let plot = grid[row][col]
                            
                            ZStack {
                                Image("dirt")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                
                                if let fossil = plot.fossil, fossil.found {
                                    if let fossilImage = UIImage(named: fossil.picture)?.removingWhiteBackground() {
                                        Image(uiImage: fossilImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image(fossil.picture)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                
                                if plot.state == .dug {
                                    Color.black.opacity(0.3)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(4)
                                }
                            }
                            .frame(width: 60, height: 60)
                            .onTapGesture {
                                dig(atRow: row, col: col)
                            }
                        }
                        
                    }
                    
                    .padding()
                    .background(Color.clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 50);
                    
                    
                    //INVISIBLE RESET BUTTON FOR DEMO
                    Button(action: {
                        resetGrid()
                        coinManager.resetCoins(120)
                    }) {
                        Text("Reset")
                            .foregroundColor(Color.clear)
                            .padding()
                    }
                            .background(Color.clear)
                            //.border(Color.white, width: 2)
                            //uncomment above to see where invisible reset button is
                    
 
                    
                    Spacer()
                }
                if let fossil = foundFossil {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 16) {
                            if let fossilImage = UIImage(named: fossil.picture)?.removingWhiteBackground() {
                                Image(uiImage: fossilImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(fossil.picture)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                            
                            Text(fossil.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(fossil.rarityColor)
                            
                            Text(fossil.rarity.rawValue.capitalized)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Button("Close") {
                                foundFossil = nil
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(20)
                        .padding()
                    }
                    .transition(.scale)
                    .zIndex(1)
                }
                if showInsufficientCoinsPopup {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Image(systemName: "xmark.octagon.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.yellow)

                            Text("Not Enough Coins")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("You need at least 10 coins to dig.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))

                            Button("Close") {
                                showInsufficientCoinsPopup = false
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(20)
                        .padding()
                    }
                    .zIndex(2)
                }
            }
            
            .navigationDestination(for: GameNavigation.self) { destination in
                switch destination {
                case .collectionBook:
                    CollectionBookView()
                }
            }
        }
        .onAppear {
            if isFirstLaunch() {
                setupGrid()
                markAppAsLaunched()
            } else if let savedGrid = GridStorage.load() {
                grid = savedGrid
            } else {
                setupGrid()
            }
        }
        
    }
    
    func completionPercentage() -> Int {
        let total = sharedFossils.count
        let found = fossilCollection.foundCount
        guard total > 0 else { return 0 }
        return Int((Double(found) / Double(total)) * 100)
    }
    
    func resetGrid() {
        GridStorage.clear()

        for index in fossilCollection.fossils.indices {
            fossilCollection.fossils[index].found = false
        }

        setupGrid()
    }
    func setupGrid() {
        let fossils = sharedFossils
        let rows = 6
        
        let columns = 6
        var positions: [(row: Int, col: Int)] = []
        for row in 0..<rows {
            for col in 0..<columns {
                positions.append((row, col))
            }
        }

        let shuffledFossils = fossils.shuffled()
        let shuffledPositions = positions.shuffled()

        var newGrid: [[Plot]] = Array(
            repeating: Array(repeating: Plot(state: .untouched, fossil: nil), count: columns),
            count: rows
        )

        for i in 0..<shuffledFossils.count {
            let pos = shuffledPositions[i]
            newGrid[pos.row][pos.col].fossil = shuffledFossils[i]
        }

        grid = newGrid
        GridStorage.save(grid: grid)
    }


    func dig(atRow row: Int, col: Int) {
        
        guard grid[row][col].state == .untouched else { return }
        let digCost = 10
        guard coinManager.coins >= digCost else {
            showInsufficientCoinsPopup = true
            return
        }

        coinManager.spendCoins(digCost)
        var plot = grid[row][col]
        plot.state = .dug

        if let fossil = plot.fossil, !fossil.found {
            fossilCollection.markFound(fossilName: fossil.name)

            var updatedFossil = fossil
            updatedFossil.found = true
            plot.fossil = updatedFossil

            foundFossil = updatedFossil
        }

        withAnimation {
            grid[row][col] = plot
        }

        GridStorage.save(grid: grid)

        if fossilCollection.foundCount == sharedFossils.count {
            for r in 0..<rows {
                for c in 0..<columns {
                    if grid[r][c].state == .untouched {
                        grid[r][c].state = .dug
                    }
                }
            }

            GridStorage.save(grid: grid)

            foundFossil = nil
            selectedTab = 0
        }
    }
}

func isFirstLaunch() -> Bool {
    return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
}

func markAppAsLaunched() {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(selectedTab: .constant(2))
            .environmentObject(FossilCollection(fossils: sharedFossils))
    }
}
