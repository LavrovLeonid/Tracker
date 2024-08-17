//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Леонид Лавров on 8/8/24.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell, ReusableView {
    private let emojiLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? .trackerLightGray : .clear
    }
    
    private func setupView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
