//
//  GameView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

let sharedFossils: [Fossil] = [
    Fossil(name: "Skull", rarity: .legendary, picture: "skull", found: true),
    Fossil(name: "Neck", rarity: .legendary, picture: "neck", found: true),
    Fossil(name: "Left Claw", rarity: .rare, picture: "leftClaw", found: true),
    Fossil(name: "Right Claw", rarity: .rare, picture: "rightClaw", found: true),
    Fossil(name: "Upper Tail", rarity: .rare, picture: "upperTail", found: true),
    Fossil(name: "Lower Tail", rarity: .rare, picture: "lowerTail", found: true),
    Fossil(name: "Upper Left Ribcage", rarity: .uncommon, picture:"upperLeftRib", found: true),
    Fossil(name: "Upper Right Ribcage", rarity: .uncommon, picture:"upperRightRib", found: true),
    Fossil(name: "Lower Left Ribcage", rarity: .uncommon, picture:"lowerLeftRib", found: true),
    Fossil(name: "Lower Right Ribcage", rarity: .uncommon, picture:"lowerRightRib", found: true),
    Fossil(name: "Left Thighbone", rarity: .uncommon, picture:"leftThigh", found: true),
    Fossil(name: "Right Thighbone", rarity: .uncommon, picture: "rightThigh", found: true),
    Fossil(name: "Left Shinbone", rarity: .common, picture: "leftShinbone", found: true),
    Fossil(name: "Right Shinbone", rarity: .common, picture: "rightShinbone", found: true),
    Fossil(name: "Left Foot", rarity: .common, picture: "leftFoot", found: true),
    Fossil(name: "Right Foot", rarity: .common, picture: "rightFoot", found: true),

    Fossil(name: "Left Arm", rarity: .common, picture: "leftArm", found: true),
    Fossil(name: "Right Arm", rarity: .common, picture: "rightArm", found: true)
]

struct GameView: View {
    @EnvironmentObject var fossilCollection: FossilCollection
    let columns = 6
    let rows = 6

    @State var grid: [[Plot]] = Array(
        repeating: Array(repeating: Plot(state: .untouched, fossil: nil), count: 6),
        count: 6
    )

    var body: some View {
        let layout = Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)
        ZStack {
            // Background grass image
            Image("grassBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer() // Optional: adds space above the grid

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
                                Image(fossil.picture)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }

                            if plot.state == .dug && plot.fossil == nil {
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

                Spacer() // Optional: adds space below the grid
            }
        }
        .onAppear {
            setupGrid()
        }
        
    }

    func setupGrid() {
        // Step 1: Define your unique fossils
        let fossils = sharedFossils

        // Step 2: Generate all positions in the grid
        let rows = 6
        
        let columns = 6
        var positions: [(row: Int, col: Int)] = []
        for row in 0..<rows {
            for col in 0..<columns {
                positions.append((row, col))
            }
        }

        // Step 3: Shuffle fossils and positions
        let shuffledFossils = fossils.shuffled()
        let shuffledPositions = positions.shuffled()

        // Step 4: Create grid with fossils placed at random positions
        var newGrid: [[Plot]] = Array(
            repeating: Array(repeating: Plot(state: .untouched, fossil: nil), count: columns),
            count: rows
        )

        for i in 0..<shuffledFossils.count {
            let pos = shuffledPositions[i]
            newGrid[pos.row][pos.col].fossil = shuffledFossils[i]
        }

        // Step 5: Set it as your current grid and save it
        grid = newGrid
        GridStorage.save(grid: grid)
    }


    func dig(atRow row: Int, col: Int) {
        guard grid[row][col].state == .untouched else { return }

        var plot = grid[row][col]
        plot.state = .dug

        if let fossil = plot.fossil, !fossil.found {
            fossilCollection.markFound(fossilName: fossil.name)
            // Update the plot's fossil as found
            var updatedFossil = fossil
            updatedFossil.found = true
            plot.fossil = updatedFossil
        }

        withAnimation {
            grid[row][col] = plot
        }
        GridStorage.save(grid: grid)
    }

    func color(for plot: Plot) -> Color {
        switch plot.state {
        case .untouched:
            return .brown
        case .dug:
            if let fossil = plot.fossil, fossil.found {
                return .green // or show fossil image
            } else {
                return .gray
            }
        case .foundItem:
            return .yellow // if you're still using this case
        }
    }
}

func color(for state: PlotState) -> Color {
    switch state {
    case .untouched:
        return .brown
    case .dug:
        return .gray
    case .foundItem(let item):
        return item == "Bone" ? .white : .yellow
    }
}
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(FossilCollection(fossils: sharedFossils))
    }
}
