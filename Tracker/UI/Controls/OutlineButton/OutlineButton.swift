//
//  OutlineButton.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import UIKit

final class OutlineButton: BaseButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
        configure(color: .trackerBlack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(color: UIColor) {
        setTitleColor(color, for: .normal)
        layer.borderColor = color.cgColor
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButton() {
        backgroundColor = .clear
        layer.borderWidth = 1
    }
}
