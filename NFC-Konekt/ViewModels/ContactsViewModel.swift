//
//  ContactsViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class ContactsViewModel: ObservableObject {
    @Published var contacts: [PhysicalContact] = []
    @Published var searchQuery: String = ""
    @Published var selectedCompanyFilter: String = "All"
    
    init() {
        contacts = [
            PhysicalContact(id: "p1", name: "Budi Santoso", email: "budi.s@techindo.id", phone: "+62 812 3456 7890", company: "Tech Indo", website: "techindo.id", jobTitle: "Senior Engineer", notes: "Met at Jakarta Tech Expo.", isRegisteredMember: true),
            PhysicalContact(id: "p2", name: "Linda Wijaya", email: nil, phone: "+62 855 1122 3344", company: "Retail Group", website: nil, jobTitle: "Manager", notes: nil, isRegisteredMember: false)
        ]
    }
    
    var availableCompanies: [String] {
        var companies = Set(contacts.compactMap { $0.company })
        var sorted = Array(companies).sorted()
        sorted.insert("All", at: 0)
        return sorted
    }
    
    var filteredContacts: [PhysicalContact] {
        contacts.filter { contact in
            let matchesSearch = searchQuery.isEmpty || 
                contact.name.localizedCaseInsensitiveContains(searchQuery) ||
                (contact.email?.localizedCaseInsensitiveContains(searchQuery) ?? false) ||
                (contact.jobTitle?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            
            let matchesCompany = selectedCompanyFilter == "All" || contact.company == selectedCompanyFilter
            return matchesSearch && matchesCompany
        }
    }
}
