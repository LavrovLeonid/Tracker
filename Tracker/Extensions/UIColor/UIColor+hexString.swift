//
//  UIColor+hexString.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/25/24.
//

import UIKit

extension UIColor {
    func hexString() -> String {
        let components = self.cgColor.components
        
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        return String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}
