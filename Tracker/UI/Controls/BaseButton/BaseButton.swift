//
//  BaseButton.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/5/24.
//

import UIKit

class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    }
}
