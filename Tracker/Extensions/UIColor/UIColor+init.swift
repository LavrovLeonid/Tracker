//
//  UIColor+init.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/24/24.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var rgbValue:UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
