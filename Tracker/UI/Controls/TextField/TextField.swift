//
//  TextField.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/5/24.
//

import UIKit

final class TextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        backgroundColor = .trackerBackground
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = 16
    }
    
    private func getRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 16, y: 0, width: bounds.width - 57, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        getRect(forBounds: bounds)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        getRect(forBounds: bounds)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.width - 29, y: bounds.height / 2 - 8.5, width: 17, height: 17)
    }
}
