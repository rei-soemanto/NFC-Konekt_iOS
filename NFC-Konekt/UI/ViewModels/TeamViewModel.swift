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
    @Published var currentUsage: Int = 0
    @Published var maxUsage: Int = 0
    @Published var planName: String = ""
    @Published var members: [TeamMember] = []
    
    @Published var showAddMemberSheet: Bool = false
    @Published var editingMember: TeamMember? = nil
    @Published var newMemberName: String = ""
    @Published var newMemberEmail: String = ""
    @Published var isLoading: Bool = false
    
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func loadTeam() async {
        do {
            let response = try await repository.getTeamData()
            self.currentUsage = response.currentUsage
            self.maxUsage = response.maxUsage
            self.planName = response.planName
            self.members = response.members.map { TeamMember(dto: $0) }
        } catch {
            print("Failed to fetch team: \(error)")
        }
    }
    
    func addMember() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let request = AddTeamMemberRequest(fullName: newMemberName, email: newMemberEmail, jobTitle: nil)
            let newMemberDto = try await repository.addMember(request: request)
            self.members.append(TeamMember(dto: newMemberDto))
            self.currentUsage += 1
            
            self.newMemberName = ""
            self.newMemberEmail = ""
            self.showAddMemberSheet = false
        } catch {
            print("Failed to add member: \(error)")
        }
    }
    
    func saveEditedMember(_ member: TeamMember) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let request = UpdateMemberRequest(jobTitle: member.jobTitle, isCompanyPublic: member.isCompanyPublic)
            let updatedDto = try await repository.updateMember(id: member.id, request: request)
            
            if let index = members.firstIndex(where: { $0.id == member.id }) {
                members[index] = TeamMember(dto: updatedDto)
            }
            self.editingMember = nil
        } catch {
            print("Failed to update member: \(error)")
        }
    }
    
    func removeMember(id: String) async {
        do {
            try await repository.removeMember(id: id)
            members.removeAll { $0.id == id }
            currentUsage = max(0, currentUsage - 1)
        } catch {
            print("Failed to remove member: \(error)")
        }
    }
}
