//
//  DigitalCardView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct DigitalCardView: View {
    let card: DigitalIDCard
    let userName: String
    let role: String
    let company: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(company)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                        .textCase(.uppercase)
                    
                    Text(card.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "wifi")
                    .rotationEffect(.degrees(90))
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer(minLength: 40)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(userName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(role)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Text(card.cardNumber)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding(24)
        .background(
            LinearGradient(colors: [.twIndigo600, .twViolet600], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(24)
        .shadow(color: .twIndigo600.opacity(colorScheme == .dark ? 0.2 : 0.4), radius: 20, x: 0, y: 10)
    }
}

#Preview("Light Mode") {
    ZStack {
        Color(.systemGray6).ignoresSafeArea() 
        
        DigitalCardView(
            card: DigitalIDCard(title: "Employee Badge", subtitle: "HQ & Server Room Access", cardNumber: "ID-8472-991", isPrimary: true),
            userName: "Rei Soemanto",
            role: "Full-Stack Developer",
            company: "PT. Wraksa Kencana Mukti"
        )
        .padding()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        DigitalCardView(
            card: DigitalIDCard(title: "Employee Badge", subtitle: "HQ & Server Room Access", cardNumber: "ID-8472-991", isPrimary: true),
            userName: "Rei Soemanto",
            role: "Full-Stack Developer",
            company: "PT. Wraksa Kencana Mukti"
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
