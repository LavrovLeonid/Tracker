//
//  FiltersButton.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/18/24.
//

import UIKit

final class FiltersButton: BaseButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .trackerBlue
        contentEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
