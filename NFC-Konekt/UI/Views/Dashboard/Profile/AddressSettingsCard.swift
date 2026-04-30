//
//  AddressPlaceholderCard.swift // (Or AddressSettingsCard.swift)
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct AddressSettingsCard: View {
    @ObservedObject var viewModel: AccountViewModel
    let cardBackground: Color
    let inputBackground: Color
    let primaryText: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Shipping Address").font(.system(size: 16, weight: .bold)).foregroundColor(primaryText)
                Text("Used for card delivery and billing invoices.").font(.system(size: 12)).foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                DropdownMenuBuilder(title: "Country", selection: $viewModel.country, options: viewModel.availableCountries, placeholder: "Select Country", backgroundColor: inputBackground, textColor: primaryText)
                
                DropdownMenuBuilder(title: "State / Province", selection: $viewModel.region, options: viewModel.availableRegions, placeholder: "Select Region", backgroundColor: inputBackground, textColor: primaryText, disabled: viewModel.country.isEmpty)
            }
            
            HStack(spacing: 16) {
                DropdownMenuBuilder(title: "City", selection: $viewModel.city, options: viewModel.availableCities, placeholder: "Select City", backgroundColor: inputBackground, textColor: primaryText, disabled: viewModel.region.isEmpty)
                
                CustomTextField(label: "Postal Code", text: $viewModel.postalCode, bg: inputBackground)
            }
            
            CustomTextField(label: "Street Address", text: $viewModel.street, bg: inputBackground)
            
            HStack {
                Spacer()
                Button(action: { Task { await viewModel.saveAddress() } }) {
                    HStack {
                        if viewModel.isSavingAddress {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Update Address").fontWeight(.bold)
                        }
                    }
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Color.twIndigo600).foregroundColor(.white).cornerRadius(12)
                }
                .disabled(viewModel.isSavingAddress)
            }
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
