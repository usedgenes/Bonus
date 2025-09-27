
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
    @Published var monthlyBudget: Double = 3000.0
    @Published var userCoins: Int = UserDefaults.standard.integer(forKey: "userCoins")
    @Published var userSpending: Double = 0.0
    
    init() {
        refreshUserCoinsIfNeeded()
    }
    
    // Call this to manually update userCoins at 8PM
    func refreshUserCoinsIfNeeded() {
        let now = Date()
        let calendar = Calendar.current
        let lastUpdate = UserDefaults.standard.object(forKey: "lastUserCoinsUpdate") as? Date ?? Date.distantPast
        
        // Check if it's a new day AND past 8PM
        guard !calendar.isDateInToday(lastUpdate) else { return }
        guard let eightPM = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) else { return };
        guard now >= eightPM else { return }
        
        let dailyMax = monthlyBudget / 30
        let earned = max(dailyMax - userSpending, 0)
        let coinsToAdd = Int(earned * 0.1)
        
        userCoins += coinsToAdd
        self.userSpending = 0.0
            
        // Save to persistent storage
        UserDefaults.standard.set(userCoins, forKey: "userCoins")
        UserDefaults.standard.set(Date(), forKey: "lastUserCoinsUpdate")
        }
}


struct PieMeterView: View {
    @EnvironmentObject var budgetModel: BudgetModel

    var percentage: Double // from 0.0 to 1.0
    
    var arcColor: Color {
        switch percentage {
        case ..<0.15:
            return .red
        case ..<0.5:
            return .yellow
        default:
            return .green
        }
    }
    
    var amountLeft: Double {
        budgetModel.monthlyBudget / 30.0 - budgetModel.userSpending
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
                Text(amountLeft < 0 ? "-$\(Int(amountLeft) * -1)" : "$\(Int(amountLeft))")
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

struct BudgetView: View {
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height * 0.725
    @GestureState private var dragOffset: CGFloat = 0
    @EnvironmentObject var budgetModel: BudgetModel

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
        return 1 - topOpacity
    }

    var topOffset: CGFloat {
        let middle = UIScreen.main.bounds.height * 0.725
        return (offsetY < middle) ? -(middle - offsetY) / 4 : 0
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Color.white)
                .ignoresSafeArea()
            
            VStack {
                Text("Coins: \(budgetModel.userCoins)")
                Text("Today's Remaining Money:")
                    .font(.title)
                    .bold()
                    .padding(.top, 125)
                
                if budgetModel.monthlyBudget != 0 {
                    PieMeterView(percentage: 1 - (budgetModel.userSpending / (budgetModel.monthlyBudget / 30)))
                        .padding(.top, 30)
                        .opacity(topOpacity)
                        .environmentObject(budgetModel)
                } else {
                    Text("Set your monthly budget in settings.")
                        .font(Font.title)
                }
                    
                HStack {
                    VStack(alignment: .leading) {
                        Text("Daily Max:")
                            .font(.title3)
                        Text("$\(budgetModel.monthlyBudget / 30, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Money Spent Today:")
                            .font(.title3)
                        Text("$\(budgetModel.userSpending, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }
                }
                .padding(.top, 30)
                .padding()
                .opacity(topOpacity)
                
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
                            
                            Text("$\(budgetModel.userSpending, specifier: "%.2f")")
                                .font(Font.title2)
                            
                            // add money transactions here i guess
                            // this ui kinda sucks
                        }
                            .frame(width: 350, height: 100, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .opacity(botOpacity)
                            
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 173/255, green: 216/255, blue: 230/255)) // @maymay change background color?
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
