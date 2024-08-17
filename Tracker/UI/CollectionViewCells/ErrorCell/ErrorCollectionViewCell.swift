//
//  ErrorCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/11/24.
//

import UIKit

final class ErrorCollectionViewCell: UICollectionViewCell, ReusableView {
    private var errorLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .trackerRed
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(error: String) {
        errorLabel.text = error
    }
    
    private func setupView() {
        contentView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
