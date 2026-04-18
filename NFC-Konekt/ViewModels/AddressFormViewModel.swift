//
//  AddressFormViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Combine

@MainActor
class AddressFormViewModel: ObservableObject {
    @Published var country: String = "" {
        didSet { if oldValue != country { region = ""; city = "" } }
    }
    @Published var region: String = "" {
        didSet { if oldValue != region { city = "" } }
    }
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var street: String = ""
    
    @Published var isLoading: Bool = false
    
    let allCountries = ["Indonesia", "Singapore", "United States"]
    
    var availableRegions: [String] {
        switch country {
        case "Indonesia": return ["Bali", "DKI Jakarta", "Jawa Barat", "Jawa Timur"]
        case "Singapore": return ["Central Region", "East Region", "North Region"]
        case "United States": return ["California", "New York", "Texas"]
        default: return []
        }
    }
    
    var availableCities: [String] {
        switch region {
        case "Jawa Timur": return ["Surabaya", "Malang", "Sidoarjo"]
        case "DKI Jakarta": return ["Central Jakarta", "South Jakarta", "West Jakarta"]
        case "California": return ["Los Angeles", "San Francisco"]
        case "New York": return ["New York City", "Buffalo", "Albany"]
        default: return region.isEmpty ? [] : ["\(region) City", "Other"]
        }
    }
    
    func saveAddress() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}
