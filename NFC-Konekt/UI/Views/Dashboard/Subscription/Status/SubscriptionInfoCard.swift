//
//  SubscriptionInfoCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct SubscriptionInfoCard: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    let sub: SubInfo
    @Environment(\.colorScheme) var colorScheme
    
    var cardBg: Color { colorScheme == .dark ? .twGray900 : .white }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    var isCanceled: Bool { sub.status == "CANCELED" }
    var isExpired: Bool { sub.status == "EXPIRED" }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(sub.planName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(primaryText)
                            
                            statusBadge
                        }
                        Text(isCanceled ? "Access remains active until \(sub.endDate)." : "Next billing cycle starts on \(sub.nextBillDate).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    if !isCanceled {
                        Button(action: {}) {
                            Label("Renew", systemImage: "arrow.triangle.2.circlepath")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.twIndigo600)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    if !isExpired && !isCanceled {
                        Button(action: {}) {
                            Label("Change Plan", systemImage: "arrow.up")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(colorScheme == .dark ? Color.twGray800 : .white)
                                .foregroundColor(primaryText)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                    }
                }
            }
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.twGray100.opacity(0.5))
            
            Divider()
            
            VStack(spacing: 24) {
                timelineSection
                expansionSection
                billingSection
            }
            .padding()
            
            if !isCanceled && !isExpired {
                Divider()
                HStack {
                    Spacer()
                    Button(action: { withAnimation { viewModel.showCancelModal = true } }) {
                        Text("Cancel Subscription")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.black.opacity(0.1) : Color.gray.opacity(0.05))
            }
        }
        .background(cardBg)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var statusBadge: some View {
        Text(isCanceled ? "Cancels Soon" : sub.status)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isCanceled ? Color.orange.opacity(0.2) : (isExpired ? Color.red.opacity(0.2) : Color.green.opacity(0.2)))
            .foregroundColor(isCanceled ? .orange : (isExpired ? .red : .green))
            .cornerRadius(6)
            .textCase(.uppercase)
    }
    
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Timeline")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(sub.remainingDays) Days Left").font(.caption).fontWeight(.bold).foregroundColor(.twIndigo600)
                    Spacer()
                    Text(sub.endDate).font(.caption).foregroundColor(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.2)).frame(height: 8)
                        RoundedRectangle(cornerRadius: 4).fill(Color.twIndigo600)
                            .frame(width: geo.size.width * CGFloat(sub.progressPercentage / 100), height: 8)
                    }
                }.frame(height: 8)
            }
        }
    }
    
    private var expansionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Expansion Packs")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color.orange.opacity(0.2)).frame(width: 40, height: 40)
                    Image(systemName: "square.stack.3d.up.fill").foregroundColor(.orange)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(sub.expansionPacks) Active Pack(s)").font(.subheadline).fontWeight(.bold).foregroundColor(primaryText)
                    Text("+\(sub.expansionPacks * 10) Team Members").font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Button("Buy More") {}.font(.caption).fontWeight(.bold).foregroundColor(.orange)
            }
            .padding()
            .background(Color.orange.opacity(0.05))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.2), lineWidth: 1))
        }
    }
    
    private var billingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Next Bill Estimate")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            if isCanceled {
                VStack(spacing: 8) {
                    Image(systemName: "xmark.circle").font(.title).foregroundColor(.gray.opacity(0.5))
                    Text("No future bill.").font(.subheadline).fontWeight(.medium).foregroundColor(.secondary)
                    Text("Subscription ends on \(sub.endDate)").font(.caption).foregroundColor(.secondary)
                }.frame(maxWidth: .infinity).padding(.vertical, 10)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Text("\(sub.planName) (\(sub.planDurationLabel))").font(.subheadline).foregroundColor(.secondary)
                        Spacer()
                        Text("\(sub.currency) \(viewModel.formatCurrency(sub.planPrice))").font(.subheadline).foregroundColor(primaryText)
                    }
                    if sub.expansionPacks > 0 {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Expansion x \(sub.expansionPacks)").font(.subheadline).foregroundColor(.secondary)
                                Text("(\(sub.currency) \(viewModel.formatCurrency(sub.expansionPrice)) / pack)").font(.caption2).foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(sub.currency) \(viewModel.formatCurrency(sub.expansionPrice * sub.expansionPacks))").font(.subheadline).foregroundColor(primaryText)
                        }
                    }
                    Divider()
                    HStack {
                        Text("Total Due").font(.headline).foregroundColor(primaryText)
                        Spacer()
                        Text("\(sub.currency) \(viewModel.formatCurrency(sub.nextBillAmount))").font(.headline).foregroundColor(.twIndigo600)
                    }
                    Text("Due Date: \(sub.nextBillDate)").font(.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .background(colorScheme == .dark ? Color.gray.opacity(0.1) : Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

#Preview("Active Subscription") {
    let container = DIContainer()
    let vm = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    let mockSub = SubInfo(
        planId: "mock_123",
        status: "ACTIVE",
        startDate: "18 April 2025",
        endDate: "18 April 2026",
        expansionPacks: 2,
        planName: "Corporate Pro",
        planPrice: 1500000,
        planDurationLabel: "1 Year",
        expansionPrice: 500000,
        currency: "IDR",
        nextBillAmount: 2500000,
        nextBillDate: "18 April 2026",
        remainingDays: 14,
        progressPercentage: 96.0
    )
    
    return ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            SubscriptionInfoCard(viewModel: vm, sub: mockSub)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Canceled State - Dark") {
    let container = DIContainer()
    let vm = SubscriptionViewModel(repository: container.subscriptionRepository)
    
    let mockSub = SubInfo(
        planId: "mock_123",
        status: "CANCELED",
        startDate: "18 April 2025",
        endDate: "18 April 2026",
        expansionPacks: 1,
        planName: "Personal Pro",
        planPrice: 500000,
        planDurationLabel: "1 Month",
        expansionPrice: 100000,
        currency: "IDR",
        nextBillAmount: 0,
        nextBillDate: "N/A",
        remainingDays: 5,
        progressPercentage: 85.0
    )
    
    return ZStack {
        Color.twGray950.ignoresSafeArea()
        
        ScrollView {
            SubscriptionInfoCard(viewModel: vm, sub: mockSub)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
