//
//  TeamStatsCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct TeamStatsCard: View {
    @ObservedObject var viewModel: TeamViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var percentage: Double {
        // Ensure we don't divide by zero if maxUsage isn't loaded yet
        guard viewModel.maxUsage > 0 else { return 0.0 }
        return min((Double(viewModel.currentUsage) / Double(viewModel.maxUsage)), 1.0)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Team Usage")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("\(viewModel.currentUsage)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            Text("/ \(viewModel.maxUsage)")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.black.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white)
                            .frame(width: geometry.size.width * CGFloat(percentage), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding()
            .background(Color.twIndigo600)
            .cornerRadius(16)
            .shadow(color: Color.twIndigo600.opacity(0.3), radius: 10, x: 0, y: 4)
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: "crown.fill")
                        .foregroundColor(.purple)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Plan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.planName)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                }
                Spacer()
            }
            .padding()
            .background(cardBackground)
            .cornerRadius(16)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}

#Preview("Light Mode") {
    let container = DIContainer()
    let viewModel = TeamViewModel(repository: container.teamRepository)
    
    return ZStack {
        Color.twGray100.ignoresSafeArea()
        
        VStack {
            TeamStatsCard(viewModel: viewModel)
            Spacer()
        }
        .padding(.top)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let container = DIContainer()
    let viewModel = TeamViewModel(repository: container.teamRepository)
    
    return ZStack {
        Color.twGray950.ignoresSafeArea()
        
        VStack {
            TeamStatsCard(viewModel: viewModel)
            Spacer()
        }
        .padding(.top)
    }
    .preferredColorScheme(.dark)
}
