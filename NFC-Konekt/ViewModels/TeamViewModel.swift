//
//  TeamMember.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine

@MainActor
class TeamViewModel: ObservableObject {
    
    @Published var currentUsage: Int = 12
    @Published var maxUsage: Int = 20
    @Published var planName: String = "Corporate Pro"
    @Published var canUpgrade: Bool = true
    
    @Published var members: [TeamMember] = []
    
    @Published var showAddMemberSheet: Bool = false
    @Published var editingMember: TeamMember? = nil
    
    @Published var newMemberName: String = ""
    @Published var newMemberEmail: String = ""
    @Published var isLoading: Bool = false
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        members = [
            TeamMember(id: "1", fullName: "Antonius Pramudiya", email: "antonius@wraksa.com", jobTitle: "CEO", isCompanyPublic: true, avatarUrl: nil),
            TeamMember(id: "2", fullName: "Budi Santoso", email: "budi@wraksa.com", jobTitle: "Lead Engineer", isCompanyPublic: true, avatarUrl: nil),
            TeamMember(id: "3", fullName: "Sarah Jenkins", email: "sarah@wraksa.com", jobTitle: "Marketing Intern", isCompanyPublic: false, avatarUrl: nil)
        ]
    }
    
    // Actions
    func addMember() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let newMem = TeamMember(
            id: UUID().uuidString,
            fullName: newMemberName,
            email: newMemberEmail,
            jobTitle: nil,
            isCompanyPublic: true,
            avatarUrl: nil
        )
        
        members.append(newMem)
        currentUsage += 1
        
        // Reset and close
        newMemberName = ""
        newMemberEmail = ""
        isLoading = false
        showAddMemberSheet = false
    }
    
    func saveEditedMember(_ member: TeamMember) async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        if let index = members.firstIndex(where: { $0.id == member.id }) {
            members[index] = member
        }
        
        isLoading = false
        editingMember = nil
    }
    
    func removeMember(id: String) async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        members.removeAll { $0.id == id }
        currentUsage = max(0, currentUsage - 1)
    }
}
