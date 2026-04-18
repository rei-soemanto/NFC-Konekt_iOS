//
//  SocialLinkItem.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

@MainActor
class AccountViewModel: ObservableObject {
    @Published var fullName: String = "Antonius Pramudiya"
    @Published var email: String = "antonius@wraksa.com"
    @Published var phone: String = "+62 812 3456 7890"
    @Published var companyName: String = "PT. Wraksa Kencana Mukti"
    @Published var companyWebsite: String = "wraksa.com"
    @Published var bio: String = "Full-stack developer bridging hardware and software."
    
    @Published var socialLinks: [SocialLinkItem] = [
        SocialLinkItem(platform: "LinkedIn", url: "https://linkedin.com/in/antonius"),
        SocialLinkItem(platform: "Github", url: "https://github.com/antonius")
    ]
    
    @Published var isCorporateAdmin: Bool = true
    @Published var companyScope: String = "Technology"
    @Published var companySpeciality: String = "Software"
    @Published var companyDescription: String = "We build digital solutions for the future."
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var showDeleteConfirmation: Bool = false
    
    @Published var isLoading: Bool = false
    
    let platformOptions = ["Whatsapp", "LinkedIn", "Instagram", "Github", "Twitter", "Website", "Facebook", "YouTube"]
    let scopeOptions = ["All", "Technology", "Design", "Retail", "Finance"]
    let specialityOptions = ["All", "Software", "Hardware", "UI/UX", "Consulting"]
    
    func addSocialLink() {
        socialLinks.append(SocialLinkItem(platform: "Website", url: ""))
    }
    
    func removeSocialLink(at index: Int) {
        socialLinks.remove(at: index)
    }
    
    func saveProfile() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
    
    func changePassword() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        currentPassword = ""
        newPassword = ""
        isLoading = false
    }
    
    func deleteAccount() {
        print("Account deleted")
    }
}
