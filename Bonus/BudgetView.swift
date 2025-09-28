
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
        budgetModel.monthlyBudget / 30.0 - userSpending
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

var userSpending = 0.0

struct BudgetView: View {
    @State private var offsetY: CGFloat = UIScreen.main.bounds.height * 0.725
    @GestureState private var dragOffset: CGFloat = 0
    @EnvironmentObject var budgetModel: BudgetModel
    @State private var withdrawals: [Withdrawal] = []
    @State private var isLoading = true
    @EnvironmentObject var customer: CustomerStore
    @EnvironmentObject var coinManager: CoinManager
    let withdrawalRequest = WithdrawalRequest()

    
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
                Text("Today's Remaining Money:")
                    .font(.title)
                    .bold()
                    .padding(.top, 125)
                
                if budgetModel.monthlyBudget != 0 {
                    PieMeterView(percentage: 1 - (userSpending / (budgetModel.monthlyBudget / 30)))
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
                        Text("$\(userSpending, specifier: "%.2f")")
                            .font(.title2)
                            .bold()
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
                .opacity(topOpacity)
                Button {
                    Task {
                        if (await !checkIfWithdrawalsExceededDailyMax()) {
                            coinManager.addCoins(Int(budgetModel.monthlyBudget / 30.0 - userSpending))
                        }
                    }
                } label: {
                    Label("Refresh Coins", systemImage: "arrow.clockwise")
                        .font(.title2.bold())
                        .frame(maxWidth: 300, minHeight: 20)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)

                Button {
                    coinManager.resetCoins()
                } label: {
                    Label("Reset Coins", systemImage: "trash")
                        .font(.title2.bold())
                        .frame(maxWidth: 300, minHeight: 20)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                
            }
            .scaleEffect(topScale)
            .offset(y: topOffset)
            
            VStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                HStack {
                    Text("Recent Transactions:")
                        .font(Font.title.bold())
                        .padding()
                    Button(action: {
                        Task {
                            await loadWithdrawals()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                    }
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if (customer.account == nil) {
                            Text("No account added")
                        }
                        else {
                            if isLoading {
                                ProgressView("Loading...")
                            } else if withdrawals.isEmpty {
                                Text("No withdrawals found.")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(withdrawals, id: \.withdrawalId) { withdrawal in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Withdrawal ID: \(withdrawal.withdrawalId)")
                                            .font(.headline)
                                        Text("Amount: $\(withdrawal.amount, specifier: "%.2f")")
                                        Text("Status: \(withdrawal.status.rawValue.capitalized)")
                                        Text("Date: \(withdrawal.transactionDate ?? "N/A")")
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding()
                    .task {
                        await loadWithdrawals()
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
            .onAppear {
                scheduleDailyAtCertainTime(for: .current) {
                    Task {
                        if (await checkIfWithdrawalsExceededDailyMax()) {
                            print("bad")
                        }
                        else {
                            print("good")
                        }
                    }
                }
                Task {
                    if (customer.customer != nil && customer.account != nil) {
                        var withdrawals = await customer.getAllWithdrawalsFromAccount()
                        if (withdrawals.count > 0) {
                            var totalWithdrawals : Double = 0
                            for withdrawal in withdrawals {
                                totalWithdrawals += withdrawal.amount
                            }
                            userSpending = totalWithdrawals
                        }
                    }
                }
            }
        }
    }
    
    func checkIfWithdrawalsExceededDailyMax() async -> Bool {
        withdrawals = await customer.getAllWithdrawalsFromAccount()
        if (withdrawals.count > 0) {
            var totalWithdrawals : Double = 0
            for withdrawal in withdrawals {
                totalWithdrawals += withdrawal.amount
            }
            if (totalWithdrawals <= budgetModel.monthlyBudget / 30) {
                return false
            }
            return true
        }
        return true
    }
    
    func loadWithdrawals() async {
        if(customer.account == nil) {
            
        }
        else { do {
            if let result = try await withdrawalRequest.getWithdrawalsFromAccountId(customer.account!.accountId) {
                withdrawals = result
            }
        } catch {
            print("Failed to load withdrawals:", error)
        }
            isLoading = false
        }
    }
}

func scheduleDailyAtCertainTime(for timeZone: TimeZone = .current, action: @escaping () -> Void) {
    let calendar = Calendar.current
    let now = Date()

    var calendarWithZone = calendar
    calendarWithZone.timeZone = timeZone

    var components = calendarWithZone.dateComponents([.year, .month, .day], from: now)
    components.hour = 23
    components.minute = 18
    components.second = 0

    guard let todayAtTen = calendarWithZone.date(from: components) else { return }

    let nextRun = todayAtTen < now
        ? calendarWithZone.date(byAdding: .day, value: 1, to: todayAtTen)!
        : todayAtTen

    let interval = nextRun.timeIntervalSinceNow

    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        action()
        scheduleDailyAtCertainTime(for: timeZone, action: action) // reschedule
    }
}

#Preview {
    BudgetView()
        .environmentObject(FossilCollection(fossils: sharedFossils))
        .environmentObject(BudgetModel())
        .environmentObject(CustomerStore())
}

