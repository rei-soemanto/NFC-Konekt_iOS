//
//  TransactionRowView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TransactionRowView: View {
    let tx: TransactionItem
    let formattedAmount: String
    let isLast: Bool
    let primaryText: Color
    
    var txTitle: String {
        switch tx.type {
        case "NEW": return "Subscription Plan"
        case "EXPANSION": return "Expansion Pack"
        case "RENEW": return "Renewal"
        default: return "Transaction"
        }
    }
    
    var isArrived: Bool {
        tx.shipmentStatus == "ARRIVED"
    }
    
    var iconName: String {
        tx.type == "RENEW" ? "arrow.triangle.2.circlepath" : "receipt"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isArrived ? Color.green.opacity(0.1) : Color.twIndigo600.opacity(0.1))
                        .frame(width: 40, height: 40)
                    Image(systemName: iconName)
                        .foregroundColor(isArrived ? .green : .twIndigo600)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(txTitle)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryText)
                    Text("\(tx.createdAt.formatted(date: .abbreviated, time: .omitted)) • \(tx.paymentId)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Amount & Status
                VStack(alignment: .trailing, spacing: 4) {
                    Text("IDR \(formattedAmount)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(primaryText)
                    
                    if tx.type != "RENEW" {
                        Text(tx.shipmentStatus)
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(isArrived ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                            .foregroundColor(isArrived ? .green : .blue)
                            .cornerRadius(4)
                    }
                }
            }
            .padding()
            
            if !isLast {
                Divider().padding(.leading, 64)
            }
        }
    }
}

#Preview("Transaction Rows") {
    VStack(spacing: 0) {
        TransactionRowView(
            tx: TransactionItem(
                id: "1",
                type: "NEW",
                createdAt: Date(),
                paymentId: "PAY-123",
                shipmentStatus: "ARRIVED",
                amount: 1500000
            ),
            formattedAmount: "1.500.000",
            isLast: false,
            primaryText: .primary
        )
        
        TransactionRowView(
            tx: TransactionItem(
                id: "2",
                type: "EXPANSION",
                createdAt: Date().addingTimeInterval(-86400),
                paymentId: "PAY-456",
                shipmentStatus: "SHIPPING",
                amount: 500000
            ),
            formattedAmount: "500.000",
            isLast: false,
            primaryText: .primary
        )
        
        TransactionRowView(
            tx: TransactionItem(
                id: "3",
                type: "RENEW",
                createdAt: Date().addingTimeInterval(-172800),
                paymentId: "PAY-789",
                shipmentStatus: "ARRIVED",
                amount: 1500000
            ),
            formattedAmount: "1.500.000",
            isLast: true,
            primaryText: .primary
        )
    }
    .background(Color(.systemBackground))
    .previewLayout(.sizeThatFits)
}
