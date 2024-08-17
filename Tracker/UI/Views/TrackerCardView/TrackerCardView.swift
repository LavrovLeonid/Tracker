//
//  TrackerCardView.swift
//  Tracker
//
//  Created by Леонид Лавров on 7/28/24.
//

import UIKit

final class TrackerCardView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let emojiView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .white.withAlphaComponent(0.3)
        
        return view
    }()
    private let emojiLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker) {
        backgroundColor = tracker.color.uiColor
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 18
        layer.masksToBounds = true
        
        emojiView.addSubview(emojiLabel)
        
        stackView.addArrangedSubview(emojiView)
        stackView.addArrangedSubview(nameLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
    }
}
