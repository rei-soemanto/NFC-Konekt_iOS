//
//  ShipmentTrackerCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ShipmentTrackerCard: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    let status: String
    @Environment(\.colorScheme) var colorScheme
    
    var cardBg: Color { colorScheme == .dark ? .twGray900 : .white }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    
    let steps = ["PROCESSING", "SHIPPING", "ARRIVED"]
    var currentStepIdx: Int { steps.firstIndex(of: status) ?? -1 }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if status == "ARRIVED" {
                VStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.green.opacity(0.1)).frame(width: 64, height: 64)
                        Image(systemName: "shippingbox.fill").foregroundColor(.green).font(.title)
                    }
                    Text("No Active Shipping").font(.headline).foregroundColor(primaryText)
                    Text("Your last shipment has arrived.").font(.subheadline).foregroundColor(.secondary)
                }.frame(maxWidth: .infinity).padding(.vertical, 10)
            } else {
                HStack {
                    Image(systemName: "map.fill").foregroundColor(.twIndigo600)
                    Text("Shipment Tracking").font(.headline).foregroundColor(primaryText)
                }
                Text("Track your card delivery status.").font(.caption).foregroundColor(.secondary)
                
                // Custom Stepper
                VStack(spacing: 8) {
                    GeometryReader { geo in
                        let stepWidth = geo.size.width / 2
                        ZStack(alignment: .leading) {
                            Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 4).offset(y: 18)
                            Rectangle().fill(Color.twIndigo600)
                                .frame(width: stepWidth * CGFloat(max(0, currentStepIdx)), height: 4)
                                .offset(y: 18)
                            
                            HStack(spacing: 0) {
                                stepIcon(icon: "shippingbox", idx: 0, label: "Processing")
                                Spacer()
                                stepIcon(icon: "box.truck", idx: 1, label: "On The Way")
                                Spacer()
                                stepIcon(icon: "house", idx: 2, label: "Delivered")
                            }
                        }
                    }.frame(height: 60)
                }.padding(.vertical, 10)
                
                Divider()
                
                HStack {
                    if status == "SHIPPING", let urlString = viewModel.subData?.shipment?.trackingLink, let url = URL(string: urlString) {
                        Link(destination: url) {
                            Label("Track Package", systemImage: "arrow.up.right.square")
                                .font(.caption).fontWeight(.bold).padding(.horizontal, 16).padding(.vertical, 10)
                                .background(Color.twIndigo600.opacity(0.1)).foregroundColor(.twIndigo600).cornerRadius(20)
                        }
                        Spacer()
                        Button(action: { Task { await viewModel.markShipmentReceived() } }) {
                            HStack {
                                if viewModel.isActionLoading { 
                                    ProgressView().scaleEffect(0.7)
                                } else {
                                    Label("Received", systemImage: "checkmark.seal.fill")
                                }
                            }
                            .font(.caption).fontWeight(.bold).padding(.horizontal, 16).padding(.vertical, 10)
                            .background(Color.green).foregroundColor(.white).cornerRadius(20)
                        }.disabled(viewModel.isActionLoading)
                    } else {
                        Text("Tracking available soon.").font(.caption).foregroundColor(.secondary).italic()
                    }
                }
            }
        }
        .padding()
        .background(cardBg)
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private func stepIcon(icon: String, idx: Int, label: String) -> some View {
        let isCompleted = idx <= currentStepIdx
        return VStack(spacing: 6) {
            ZStack {
                Circle().fill(isCompleted ? Color.twIndigo600 : (colorScheme == .dark ? Color.twGray800 : .white))
                    .frame(width: 40, height: 40)
                    .overlay(Circle().stroke(isCompleted ? Color.clear : Color.gray.opacity(0.3), lineWidth: 2))
                Image(systemName: icon).foregroundColor(isCompleted ? .white : .gray).font(.system(size: 14, weight: .bold))
            }
            Text(label).font(.system(size: 10, weight: .bold)).foregroundColor(isCompleted ? .twIndigo600 : .gray).textCase(.uppercase)
        }.frame(width: 80)
    }
}
