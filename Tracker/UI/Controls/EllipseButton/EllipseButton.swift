//
//  EllipseButton.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/3/24.
//

import UIKit

final class EllipseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        
        layer.cornerRadius = 17
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 34),
            heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
