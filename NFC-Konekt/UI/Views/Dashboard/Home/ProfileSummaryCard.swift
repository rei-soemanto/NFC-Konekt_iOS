//
//  ProfileSummaryCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import SwiftUI

struct ProfileSummaryCard: View {
    let fullName: String
    let companyName: String
    let avatarUrl: String?
    let onEditClick: () -> Void
    let onPreviewClick: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Info Row
            HStack(spacing: 16) {
                // Avatar Box
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    if let url = avatarUrl.toFullImageURL() {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFill().frame(width: 64, height: 64).clipShape(Circle())
                            default:
                                FallbackInitial(name: fullName)
                            }
                        }
                    } else {
                        FallbackInitial(name: fullName)
                    }
                }
                
                // Text Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(fullName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(companyName)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("ACTIVE • PUBLIC")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                Spacer()
            }
            
            // Buttons Row
            HStack(spacing: 12) {
                // ShareLink is the native SwiftUI equivalent to Android's Intent.ACTION_SEND
                ShareLink(item: URL(string: "https://yourdomain.com/p/your-id")!, message: Text("Connect with me on NFC Konekt!")) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                        Text("Share")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white)
                    .foregroundColor(.twViolet600)
                    .cornerRadius(12)
                }
                
                Button(action: onEditClick) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                        Text("Edit")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(colors: [.twViolet600, .twIndigo600], startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(20)
        .onTapGesture {
            onPreviewClick()
        }
    }
}

private struct FallbackInitial: View {
    let name: String
    var body: some View {
        Text(String(name.prefix(1)).uppercased())
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
    }
}
