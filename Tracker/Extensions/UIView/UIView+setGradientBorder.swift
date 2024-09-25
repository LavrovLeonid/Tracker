//
//  UIView+setGradientBorder.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/21/24.
//

import UIKit

extension UIView {
    func setGradientBorder(
        width: CGFloat = 1,
        colors: [UIColor],
        cornerRadius: CGFloat = 0,
        startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5)
    ) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = width
        
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
}
