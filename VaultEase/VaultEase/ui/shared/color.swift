//
//  color.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/21/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        _ = scanner.scanString("#")
        scanner.scanHexInt64(&hexNumber)
        
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255
        let b = Double(hexNumber & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}
