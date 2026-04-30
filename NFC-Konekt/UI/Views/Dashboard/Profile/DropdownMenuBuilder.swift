//
//  DropdownMenuBuilder.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 30/04/26.
//

import SwiftUI

struct DropdownMenuBuilder: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let placeholder: String
    let backgroundColor: Color
    let textColor: Color
    var disabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection = option }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? placeholder : selection)
                        .foregroundColor(selection.isEmpty ? .gray.opacity(0.7) : textColor)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(disabled ? backgroundColor.opacity(0.5) : backgroundColor)
                .cornerRadius(10)
            }
            .disabled(disabled)
        }
    }
}
