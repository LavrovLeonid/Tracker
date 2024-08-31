//
//  PrimaryButton.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/5/24.
//

import UIKit

final class PrimaryButton: BaseButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isEnabled: Bool) {
        self.isEnabled = isEnabled
        backgroundColor = isEnabled ? .trackerBlack : .trackerGray
    }
    
    private func setupButton() {
        backgroundColor = .trackerBlack
        setTitleColor(.trackerWhite, for: .normal)
        setTitleColor(.trackerWhite, for: .disabled)
    }
}
