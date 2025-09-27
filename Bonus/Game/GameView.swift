//
//  GameView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

let sharedFossils: [Fossil] = [
    Fossil(name: "Skull", rarity: .legendary, picture: "skull"),
    Fossil(name: "Neck", rarity: .legendary, picture: "neck"),
    Fossil(name: "Left Claw", rarity: .rare, picture: "trex"),
    // add the rest of your fossils here
]

struct GameView: View {
    let columns = 6
    let rows = 6

    @State var grid: [[Plot]] = Array(
        repeating: Array(repeating: Plot(state: .untouched, fossil: nil), count: 6),
        count: 6
    )

    var body: some View {
        let layout = Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)

        ScrollView {
            LazyVGrid(columns: layout, spacing: 2) {
                ForEach(0..<(rows * columns), id: \.self) { index in
                    let row = index / columns
                    let col = index % columns
                    let plot = grid[row][col]
                    
                    Rectangle()
                        .fill(color(for: plot))
                        .frame(height: 30)
                        .onTapGesture {
                            dig(atRow: row, col: col)
                        }
                }
            }
            .padding()
        }
        .onAppear {
            setupGrid()
        }
        VStack(spacing: 20) {
            Text("Hello, SwiftUI!")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
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

//        if let fossil = plot.fossil, !fossil.found {
//            fossilCollection.markFound(fossilName: fossil.name)
//            // Update the plot's fossil as found
//            var updatedFossil = fossil
//            updatedFossil.found = true
//            plot.fossil = updatedFossil
//        }

        grid[row][col] = plot
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
