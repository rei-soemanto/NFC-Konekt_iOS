//
//  DigitalIDCard.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 18/04/26.
//

import Foundation

struct DigitalIDCard: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let cardNumber: String
    let isPrimary: Bool
}
