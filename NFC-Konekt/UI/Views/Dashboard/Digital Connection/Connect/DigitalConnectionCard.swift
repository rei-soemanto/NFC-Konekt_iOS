//
//  DigitalConnectCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto.
//

import SwiftUI

struct DigitalConnectCard: View {
    let fullName: String
    let companyName: String?
    let website: String?
    let email: String
    let avatarUrl: String?
    let socialLinks: [SocialLinkItem]
    let connectionStatus: ConnectionStatus
    let onConnectClick: () -> Void
    var isPreviewMode: Bool = false
    
    @Environment(\.openURL) var openURL
    
    let cardBackground = Color(red: 30/255, green: 41/255, blue: 59/255) 
    let bannerBackground = LinearGradient(colors: [.twViolet600, .twIndigo600], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .top) {
                bannerBackground
                    .frame(height: 120)
                    .overlay(alignment: .topTrailing) {
                        if isPreviewMode {
                            HStack(spacing: 6) {
                                Image(systemName: "eye.fill").font(.system(size: 12))
                                Text("Preview Mode").font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Capsule())
                            .padding(16)
                        }
                    }
                
                ZStack {
                    Circle()
                        .fill(cardBackground)
                        .frame(width: 132, height: 132)
                    
                    if let url = avatarUrl.toFullImageURL() {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                fallbackInitial
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    } else {
                        fallbackInitial
                    }
                }
                .offset(y: 60)
            }
            .frame(height: 180)
            
            VStack(spacing: 12) {
                Text(fullName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                if let company = companyName, !company.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill").font(.system(size: 14))
                        Text(company).font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Color(red: 140/255, green: 150/255, blue: 255/255))
                }
                
                if let web = website, !web.isEmpty {
                    Button(action: {
                        let urlStr = web.hasPrefix("http") ? web : "https://\(web)"
                        if let url = URL(string: urlStr) { openURL(url) }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "link").font(.system(size: 14))
                            Text(web.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: ""))
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
                    if let url = URL(string: "mailto:\(email)") { openURL(url) }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "envelope").font(.system(size: 14))
                        Text(email).font(.system(size: 14))
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .overlay(Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.top, 4)
                
                Spacer().frame(height: 8)
                
                actionButtons
                
                Spacer().frame(height: 12)
                
                if !socialLinks.isEmpty {
                    VStack(spacing: 12) {
                        ForEach(socialLinks) { link in
                            socialLinkRow(link)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            .padding(.bottom, 24)
        }
        .background(cardBackground)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.05), lineWidth: 1)
        )
    }
    
    private var fallbackInitial: some View {
        ZStack {
            Color(red: 15/255, green: 23/255, blue: 42/255)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            Text(String(fullName.prefix(1)).uppercased())
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: 12) {
            
            let config: (text: String, bg: Color, icon: String, textCol: Color) = {
                switch connectionStatus {
                case .notConnected:
                    return ("Connect", Color(red: 99/255, green: 102/255, blue: 241/255), "person.badge.plus", .white)
                case .connected:
                    return ("Connected", Color.green.opacity(0.2), "checkmark", .green)
                case .selfUser:
                    return ("It's You", Color.white.opacity(0.05), "person.fill", Color.white.opacity(0.3))
                }
            }()
            
            Button(action: {
                if connectionStatus == .notConnected { onConnectClick() }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: config.icon).font(.system(size: 15))
                    Text(config.text).font(.system(size: 15, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(config.bg)
                .foregroundColor(config.textCol)
                .cornerRadius(12)
            }
            .disabled(connectionStatus != .notConnected)
        }
    }
    
    private func socialLinkRow(_ link: SocialLinkItem) -> some View {
        Button(action: {
            let urlStr = link.url.hasPrefix("http") ? link.url : "https://\(link.url)"
            if let url = URL(string: urlStr) { openURL(url) }
        }) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.1)).frame(width: 32, height: 32)
                        Image(systemName: platformIcon(for: link.platform))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    Text(link.platform)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func platformIcon(for platform: String) -> String {
        switch platform.lowercased() {
        case "github": return "curlybraces"
        case "website": return "globe"
        case "linkedin": return "briefcase.fill"
        case "email": return "envelope.fill"
        case "instagram", "facebook", "twitter": return "at"
        case "youtube": return "play.rectangle.fill"
        default: return "link"
        }
    }
}
