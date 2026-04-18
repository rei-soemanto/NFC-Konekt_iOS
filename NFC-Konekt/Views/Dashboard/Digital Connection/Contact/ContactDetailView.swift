//
//  ContactDetailView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: PhysicalContact
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var appBackground: Color { colorScheme == .dark ? .twGray950 : .twGray100 }
    var cardBackground: Color { colorScheme == .dark ? .twGray900 : .white }
    
    var body: some View {
        ZStack {
            appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(contact.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    if contact.isRegisteredMember {
                                        HStack(spacing: 4) {
                                            Circle().fill(Color.green).frame(width: 6, height: 6)
                                            Text("MEMBER")
                                                .font(.system(size: 10, weight: .bold))
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .foregroundColor(.green)
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.5), lineWidth: 1))
                                    }
                                }
                                
                                Text(contact.jobTitle ?? "No Title")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                if let comp = contact.company {
                                    Label(comp, systemImage: "building.fill")
                                        .font(.caption)
                                        .padding(.horizontal, 10).padding(.vertical, 6)
                                        .background(Color.white.opacity(0.1))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 70, height: 70)
                                Text(String(contact.name.prefix(1)))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        LinearGradient(colors: [colorScheme == .dark ? Color.twIndigo600.opacity(0.5) : Color(hex: "#111827"), colorScheme == .dark ? Color.twViolet600.opacity(0.5) : Color(hex: "#1F2937")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("CONTACT INFORMATION")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            InfoRow(icon: "envelope.fill", title: "Email Address", value: contact.email)
                            Divider().padding(.leading, 56)
                            InfoRow(icon: "phone.fill", title: "Phone Number", value: contact.phone)
                            Divider().padding(.leading, 56)
                            InfoRow(icon: "globe", title: "Website", value: contact.website, isLink: true)
                        }
                        .background(cardBackground)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("SCANNED NOTES")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Text(contact.notes ?? "No additional text was extracted from the card.")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? .white : .twGray900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(cardBackground)
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Light Mode") {
    NavigationView {
        ContactDetailView(contact: PhysicalContact(id: "1", name: "Budi Santoso", email: "budi.s@techindo.id", phone: "+62 812 3456 7890", company: "Tech Indo", website: "techindo.id", jobTitle: "Senior Engineer", notes: "Met at Jakarta Tech Expo.", isRegisteredMember: true))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationView {
        ContactDetailView(contact: PhysicalContact(id: "1", name: "Budi Santoso", email: "budi.s@techindo.id", phone: "+62 812 3456 7890", company: "Tech Indo", website: "techindo.id", jobTitle: "Senior Engineer", notes: "Met at Jakarta Tech Expo.", isRegisteredMember: true))
    }
    .preferredColorScheme(.dark)
}
