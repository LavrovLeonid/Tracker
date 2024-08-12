//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/10/24.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell, ReusableView {
    private let colorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
    
    private func setupView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 3
        
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
