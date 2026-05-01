//
//  TeamViewModel.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class TeamViewModel: ObservableObject {
    @Published var currentUsage: Int = 1
    @Published var maxUsage: Int = 0
    @Published var planName: String = ""
    @Published var members: [TeamMemberDto] = []
    
    @Published var showAddMemberSheet: Bool = false
    @Published var editingMember: TeamMemberDto? = nil
    
    @Published var newMemberName: String = ""
    @Published var newMemberEmail: String = ""
    
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil
    
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func loadTeam() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await repository.getTeamData()
            self.currentUsage = response.currentUsage + 1
            self.maxUsage = response.maxUsage
            self.planName = response.planName
            self.members = response.members
        } catch {
            self.errorMessage = error.localizedDescription
            print("❌ Failed to fetch team: \(error)")
        }
        isLoading = false
    }
    
    func addMember() async {
        guard !newMemberName.isEmpty, !newMemberEmail.isEmpty else { return }
        isSaving = true
        errorMessage = nil
        do {
            let request = AddTeamMemberRequest(fullName: newMemberName, email: newMemberEmail, jobTitle: nil)
            let newMemberDto = try await repository.addMember(request: request)
            
            self.members.append(newMemberDto)
            self.currentUsage += 1
            
            self.newMemberName = ""
            self.newMemberEmail = ""
            self.showAddMemberSheet = false
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isSaving = false
    }
    
    func saveEditedMember(id: String, jobTitle: String?, isPublic: Bool) async {
        isSaving = true
        errorMessage = nil
        do {
            let request = UpdateMemberRequest(jobTitle: jobTitle, isCompanyPublic: isPublic)
            let updatedDto = try await repository.updateMember(id: id, request: request)
            
            if let index = members.firstIndex(where: { $0.id == id }) {
                members[index] = updatedDto
            }
            self.editingMember = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isSaving = false
    }
    
    func removeMember(id: String) async {
        do {
            try await repository.removeMember(id: id)
            members.removeAll { $0.id == id }
            self.currentUsage = max(1, currentUsage - 1)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
