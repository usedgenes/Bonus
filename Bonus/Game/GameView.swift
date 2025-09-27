//
//  GameView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI

struct GameView: View {
    let columns = 10
    let rows = 10

    @State var grid: [[Plot]] = []

    var body: some View {
        let flatGrid = grid.flatMap { $0 }

        let layout = Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)

        ScrollView {
            LazyVGrid(columns: layout, spacing: 2) {
                ForEach(flatGrid.indices, id: \.self) { index in
                    let row = index / columns
                    let col = index % columns
                    let plot = grid[row][col]

                    Rectangle()
                        .fill(color(for: plot.state))
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
    }

    func setupGrid() {
        if let savedGrid = GridStorage.load() {
            grid = savedGrid
        } else {
            grid = Array(
                repeating: Array(repeating: Plot(state: .untouched), count: columns),
                count: rows
            )
        }
    }

    func dig(atRow row: Int, col: Int) {
        let found = Bool.random()
        let item = found ? "Bone" : "Nothing"
        grid[row][col].state = .foundItem(item)
        GridStorage.save(grid: grid)
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
    }
}
