//
//  AddressPlaceholderCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AddressSettingsCard: View {
    @StateObject private var viewModel = AddressFormViewModel()
    let cardBackground: Color
    @Environment(\.colorScheme) var colorScheme
    
    var inputBackground: Color { colorScheme == .dark ? Color.black.opacity(0.3) : Color(.systemGray6) }
    var primaryText: Color { colorScheme == .dark ? .white : .twGray900 }
    var shadowColor: Color { colorScheme == .dark ? .clear : .black.opacity(0.05) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            formSection
            saveButton
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Shipping Address")
                .font(.headline)
                .foregroundColor(primaryText)
            Text("Used for card delivery and billing invoices.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            // Row 1: Country & Region
            HStack(spacing: 16) {
                dropdownMenu(
                    title: "Country",
                    selection: $viewModel.country,
                    options: viewModel.allCountries,
                    placeholder: "Select Country"
                )
                
                dropdownMenu(
                    title: "State / Province",
                    selection: $viewModel.region,
                    options: viewModel.availableRegions,
                    placeholder: "Select Region",
                    disabled: viewModel.country.isEmpty
                )
            }
            
            // Row 2: City & Postal Code
            HStack(spacing: 16) {
                dropdownMenu(
                    title: "City",
                    selection: $viewModel.city,
                    options: viewModel.availableCities,
                    placeholder: "Select City",
                    disabled: viewModel.region.isEmpty
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Postal Code")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    TextField("", text: $viewModel.postalCode)
                        .padding()
                        .background(inputBackground)
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                }
            }
            
            // Row 3: Street
            VStack(alignment: .leading, spacing: 6) {
                Text("Street Address")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                TextEditor(text: $viewModel.street)
                    .frame(height: 80)
                    .padding(8)
                    .background(inputBackground)
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
                    .overlay(
                        VStack {
                            if viewModel.street.isEmpty {
                                HStack {
                                    Text("Unit, Building, Street Name...")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .padding(.leading, 12)
                                        .padding(.top, 16)
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                    )
            }
        }
    }
    
    private var saveButton: some View {
        HStack {
            Spacer()
            Button(action: { Task { await viewModel.saveAddress() } }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Update Address")
                    }
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.twIndigo600)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.twIndigo600.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    // Extracted Dropdown Builder
    @ViewBuilder
    private func dropdownMenu(title: String, selection: Binding<String>, options: [String], placeholder: String, disabled: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.isEmpty ? placeholder : selection.wrappedValue)
                        .foregroundColor(selection.wrappedValue.isEmpty ? .gray.opacity(0.7) : primaryText)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.gray).font(.caption)
                }
                .padding()
                .background(disabled ? inputBackground.opacity(0.5) : inputBackground)
                .cornerRadius(10)
            }
            .disabled(disabled)
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        ScrollView {
            AddressSettingsCard(cardBackground: .white)
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        ScrollView {
            AddressSettingsCard(cardBackground: Color(hex: "#111827"))
                .padding(.vertical)
        }
    }
    .preferredColorScheme(.dark)
}
