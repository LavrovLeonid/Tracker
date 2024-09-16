//
//  CompleteCountCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 9/15/24.
//

import UIKit

class CompleteCountCell: UICollectionViewCell, ReusableView {
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(completeCount: Int) {
        countLabel.text = "\(completeCount) д\(completeCount.getEnding(one: "ень", notMany: "ня", many: "ней"))"
    }
    
    private func setupView() {
        contentView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor),
            countLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
