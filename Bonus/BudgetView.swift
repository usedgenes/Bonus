
//
//  BudgetView.swift
//  Bonus
//
//  Created by Eugene on 9/26/25.
//

import SwiftUI
import Foundation
import Combine

class BudgetModel: ObservableObject {
    @Published var monthlyBudget: Int = 0
}

struct PieMeterView: View {
    var percentage: Double // from 0.0 to 1.0
    
    var arcColor: Color {
        switch percentage {
        case ..<0.2:
            return .red
        case ..<0.5:
            return .yellow
        default:
            return .green
        }
    }
    
    var amountLeft: Double {
        max(monthlyBudget / 30.0 - userSpending, 0)
    }
    
    var body: some View {
        ZStack {
            // Background circle (gray base)
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 30)

            // Foreground arc (progress)
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    arcColor,
                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Rotate so it starts at top

            // Text inside
            VStack(spacing: 4) {
                Text("$\(Int(amountLeft))")
                    .font(.largeTitle)
                    .bold()
                Text("left today")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 200, height: 200)
    }
}

var monthlyBudget = 3000.0
var userSpending = 10.0
private var showButtons = true

struct BudgetView: View {
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height * 0.7
    @GestureState private var dragOffset: CGFloat = 0
    
    var bottomHeight: CGFloat {
        return offsetY < 200 ? 400 : 200 // or pick your own sizes
    }
    
    var topScale: CGFloat {
        let minScale: CGFloat = 0.85
        let maxOffset: CGFloat = UIScreen.main.bounds.height * 0.3
        let progress = min(max((offsetY - 100) / maxOffset, 0), 1)
        return 1 - (1 - minScale) * (1 - progress)
    }

    var topOpacity: Double {
        let maxOffset: CGFloat = UIScreen.main.bounds.height * 0.3
        let progress = min(max((offsetY - 100) / maxOffset, 0), 1)
        return Double(progress)
    }
    
    var botOpacity: Double {
        let raw = 1 - topOpacity
        return 0.5 + raw * 0.5
    }

    var topOffset: CGFloat {
//        let maxOffset: CGFloat = 50
        let middle = UIScreen.main.bounds.height * 0.7
        return (offsetY < middle) ? -(middle - offsetY) / 4 : 0
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Color.white)
                .ignoresSafeArea()
            
            VStack {
                Text("Today's Remaining Money:")
                    .font(.title)
                    .bold()
                    .padding(.top, 125)
                
                PieMeterView(percentage: 1 - (userSpending / (monthlyBudget / 30)))
                    .padding(.top, 30)
                    .opacity(topOpacity)
                    
                HStack {
                    VStack(alignment: .leading) {
                        Text("Daily Max:")
                            .font(.title3)
                        Text("$\(monthlyBudget / 30, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Money Spent Today:")
                            .font(.title3)
                        Text("$\(userSpending, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }
                }
                .padding(.top, 30)
                .padding()
                .opacity(topOpacity)
                
                // this is the code for the calculator to enter the monthly budget if
                // we ever need that again
                //
                //                Text("\(monthlyBudget, specifier: "%.2f")")
                //                    .font(Font.largeTitle)
                //
                //                if showButtons {
                //                    // Calculator keypad
                //                    ForEach([[1, 2, 3], [4, 5, 6], [7, 8, 9]], id: \.self) { row in
                //                        HStack {
                //                            ForEach(row, id: \.self) { number in
                //                                Button(action: {
                //                                    monthlyBudget = monthlyBudget * 10 + number
                //                                }) {
                //                                    Text("\(number, specifier: "%.0f")")
                //                                        .frame(width: 60, height: 60)
                //                                        .background(Color.gray)
                //                                        .foregroundColor(.white)
                //                                        .cornerRadius(8)
                //                                }
                //                            }
                //                        }
                //                    }
                //
                //                    HStack {
                //                        Button("0") {
                //                            monthlyBudget = monthlyBudget * 10
                //                        }
                //                        .frame(width: 60, height: 60)
                //                        .background(Color.gray)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(8)
                //
                //                        Button("Clear") {
                //                            monthlyBudget = 0
                //                        }
                //                        .frame(width: 130, height: 60)
                //                        .background(Color.red)
                //                        .foregroundColor(.white)
                //                        .cornerRadius(8)
                //                    }
                //                }
                //
                //                Button(action: {
                //                    showButtons.toggle()
                //                }) {
                //                    Text(showButtons ? "Done" : "Enter new monthly salary")
                //                        .padding(3)
                //                        .background(Color.white)
                //                        .cornerRadius(8)
                //                }
            }
            .scaleEffect(topScale)
            .offset(y: topOffset)
            
            VStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                
                Text("Recent Transactions:")
                    .font(Font.title.bold())
                    .padding()
                
                ScrollView {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            //this is an example
                            Text("Transaction 1:")
                                .font(Font.title2)
                            
                            Text("$\(userSpending, specifier: "%.2f")")
                                .font(Font.title2)
                            
                            // add money transactions here i guess
                            // this ui kinda sucks
                        }
                            .padding(40)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .opacity(botOpacity)
                            
                        
                    }
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: .infinity)
            .background(Color(red: 173/255, green: 216/255, blue: 230/255)) // change background color?
            .cornerRadius(25)
            .shadow(radius: 10)
            .offset(y: offsetY + dragOffset)
            .onTapGesture {
                withAnimation {
                    offsetY = offsetY > 200 ? 100 : UIScreen.main.bounds.height * 0.7
                }
            }
            
            // this commented stuff is for dragging the thing up but lowk it feels weird
            // so it's click only now
//            .gesture(
//                DragGesture()
//                    .updating($dragOffset) { value, state, _ in
//                        state = value.translation.height
//                    }
//                    .onEnded { value in
//                        // Snap to top or bottom depending on drag
//                        let newOffset = offsetY + value.translation.height
//                        let middle = UIScreen.main.bounds.height * 0.7
//                        withAnimation(.easeInOut) {
//                            offsetY = newOffset < middle ? 100 : UIScreen.main.bounds.height * 0.7
//                            }
//                        }
//                )
//                .animation(.easeInOut, value: offsetY)
        }
    }
}

#Preview {
    BudgetView()
}
