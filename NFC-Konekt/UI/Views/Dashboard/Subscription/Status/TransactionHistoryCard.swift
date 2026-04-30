//
//  TransactionHistoryCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TransactionHistoryCard: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var cardBg: Color { colorScheme == .dark ? .twGray900 : .white }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "clock.arrow.circlepath").foregroundColor(.twIndigo600)
                Text("Transaction History").font(.headline).foregroundColor(primaryText)
                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.twGray100.opacity(0.5))
            
            Divider()
            
            if viewModel.transactions.isEmpty {
                Text("No completed transactions found.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.vertical, 30)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.transactions) { tx in
                        TransactionRowView(
                            tx: tx,
                            formattedAmount: viewModel.formatCurrency(tx.amount),
                            isLast: tx.id == viewModel.transactions.last?.id,
                            primaryText: primaryText
                        )
                    }
                }
            }
        }
        .background(cardBg)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    let viewModel = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    viewModel.transactions = [
        TransactionItem(id: "tx1", type: "EXPANSION", createdAt: Date().addingTimeInterval(-86400 * 5), paymentId: "PAY-987", shipmentStatus: "SHIPPING", amount: 500000),
        TransactionItem(id: "tx2", type: "NEW", createdAt: Date().addingTimeInterval(-86400 * 350), paymentId: "PAY-123", shipmentStatus: "ARRIVED", amount: 2000000)
    ]
    
    return ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            TransactionHistoryCard(viewModel: viewModel)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    let viewModel = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    viewModel.transactions = [
        TransactionItem(id: "tx1", type: "EXPANSION", createdAt: Date().addingTimeInterval(-86400 * 5), paymentId: "PAY-987", shipmentStatus: "SHIPPING", amount: 500000),
        TransactionItem(id: "tx2", type: "NEW", createdAt: Date().addingTimeInterval(-86400 * 350), paymentId: "PAY-123", shipmentStatus: "ARRIVED", amount: 2000000)
    ]
    
    return ZStack {
        Color.twGray950.ignoresSafeArea()
        
        ScrollView {
            TransactionHistoryCard(viewModel: viewModel)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
