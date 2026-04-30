//
//  CustomTextField.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import SwiftUI

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    let bg: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.caption).fontWeight(.bold).foregroundColor(.secondary)
            TextField("", text: $text)
                .padding()
                .background(bg)
                .cornerRadius(10)
        }
    }
}

struct CustomTextField_Previews: View {
    @State private var text = ""
    let label: String
    let bg: Color
    
    var body: some View {
        CustomTextField(label: label, text: $text, bg: bg)
            .padding()
    }
}

#Preview("Light Mode") {
    ZStack {
        Color.twGray100.ignoresSafeArea()
        
        VStack(spacing: 20) {
            CustomTextField_Previews(
                label: "Full Name",
                bg: Color.white
            )
            
            CustomTextField_Previews(
                label: "Job Title",
                bg: Color(.systemGray6)
            )
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ZStack {
        Color.twGray950.ignoresSafeArea()
        
        VStack(spacing: 20) {
            CustomTextField_Previews(
                label: "Full Name",
                bg: Color.twGray900
            )
            
            CustomTextField_Previews(
                label: "Job Title",
                bg: Color.black.opacity(0.3)
            )
        }
    }
    .preferredColorScheme(.dark)
}
