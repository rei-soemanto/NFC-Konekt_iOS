//
//  ScannerOverlayView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 01/05/26.
//

import SwiftUI

struct ScannerOverlayView: View {
    @ObservedObject var viewModel: ConnectViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var textPrimary: Color { colorScheme == .dark ? .white : .twGray900 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { viewModel.cancelScanning() }) {
                    Image(systemName: "arrow.left").foregroundColor(textPrimary).font(.title3)
                }
                Text("Scan NFC Card").font(.system(size: 18, weight: .bold)).foregroundColor(textPrimary).padding(.leading, 8)
                Spacer()
            }.padding()
            
            Spacer()
            
            if viewModel.isFetchingProfile {
                ProgressView("Fetching profile...").tint(.twIndigo600).foregroundColor(.gray)
            } else if let errorMessage = viewModel.scanErrorMessage {
                VStack(spacing: 16) {
                    Text("Error: \(errorMessage)").foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button("Try Again") { viewModel.resetScan() }.buttonStyle(.borderedProminent).tint(.twIndigo600)
                }
            } else if let user = viewModel.scannedUser {
                VStack {
                    Text("Found User: \(user.fullName)").font(.title2)
                    Button("Connect") { Task { await viewModel.saveContact(userId: user.id) } }
                        .buttonStyle(.borderedProminent).tint(.twIndigo600)
                    
                    Button("Scan Another") { viewModel.resetScan() }.padding(.top)
                }
            } else {
                VStack(spacing: 24) {
                    ZStack {
                        Circle().fill(Color.twIndigo600.opacity(0.1)).frame(width: 120, height: 120)
                            .overlay(Circle().stroke(Color.twIndigo600.opacity(0.3), lineWidth: 2))
                        Image(systemName: "wave.3.right").font(.system(size: 64)).foregroundColor(.twIndigo600)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Ready to Scan").font(.system(size: 22, weight: .bold)).foregroundColor(textPrimary)
                        Text("Hold your phone near an NFC Konekt card or ring to connect.").font(.system(size: 14)).foregroundColor(.gray).multilineTextAlignment(.center).padding(.horizontal)
                    }
                    
                    Divider().padding(.vertical, 8)
                    
                    Button(action: {
                        Task { await viewModel.fetchScannedProfile(slug: "test-slug") }
                    }) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                            Text("Scan QR Code Instead").fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity).frame(height: 50)
                        .foregroundColor(textPrimary)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(40).background(cardBackground).cornerRadius(24).padding(.horizontal)
            }
            Spacer()
        }
    }
}
