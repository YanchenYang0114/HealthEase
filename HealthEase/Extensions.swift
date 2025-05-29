//
//  Extensions.swift
//
//  Created by Yang on on 18/2/2025.
//

import Foundation
import SwiftUI


extension Color {
    init(hex: String,opacity:Double = 1.0) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xFF0000) >> 16
        let g = (rgbValue & 0xFF00) >> 8
        let b = rgbValue & 0xFF
        
        self.init(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0, opacity: opacity)
    }
}
