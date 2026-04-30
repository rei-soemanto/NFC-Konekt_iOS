//
//  ContactsViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

@MainActor
class ContactsViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var contacts: [PhysicalContactDto] = []
    @Published var searchQuery: String = ""
    @Published var selectedCompanyFilter: String = "All"
    @Published var errorMessage: String? = nil
    
    private let repository: ContactRepository
    
    init(repository: ContactRepository) {
        self.repository = repository
    }
    
    func loadContacts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.contacts = try await repository.getContacts()
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            print("❌ Failed to load contacts: \(error)")
        }
    }
    
    var availableCompanies: [String] {
        let companies = Set(contacts.compactMap { $0.company })
        var sorted = Array(companies).sorted()
        sorted.insert("All", at: 0)
        return sorted
    }
    
    var filteredContacts: [PhysicalContactDto] {
        contacts.filter { contact in
            let matchesSearch = searchQuery.isEmpty ||
                contact.name.localizedCaseInsensitiveContains(searchQuery) ||
                (contact.email?.localizedCaseInsensitiveContains(searchQuery) ?? false) ||
                (contact.jobTitle?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            
            let matchesCompany = selectedCompanyFilter == "All" || contact.company == selectedCompanyFilter
            
            return matchesSearch && matchesCompany
        }
    }
    
    func getContactById(id: String) -> PhysicalContactDto? {
        return contacts.first { $0.id == id }
    }
}
